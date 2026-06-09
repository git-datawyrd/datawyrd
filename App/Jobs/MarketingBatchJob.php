<?php
namespace App\Jobs;

use Core\Database;
use App\Repositories\MarketingRepository;
use App\Services\Marketing\CampaignService;
use Core\Queue;

class MarketingBatchJob
{
    /**
     * @param array $payload
     * @throws \Exception
     */
    public function handle(array $payload)
    {
        $db = Database::getInstance()->getConnection();
        $repo = new MarketingRepository($db);
        $service = new CampaignService($repo);

        // Process a batch of pending emails
        $result = $service->processBatch();

        // Clean up completed campaigns: set status to 'sent' and sent_at to NOW()
        // when all individual emails in the send_log are processed (sent or failed).
        $db->exec(
            "UPDATE mktg_campaigns c
             SET c.status = 'sent', c.sent_at = NOW()
             WHERE c.status = 'sending'
               AND NOT EXISTS (
                   SELECT 1 FROM mktg_send_log sl
                   WHERE sl.campaign_id = c.id
                     AND sl.status IN ('queued', 'processing')
               )"
        );

        // Activate scheduled campaigns whose time has come
        $activatedStmt = $db->prepare(
            "UPDATE mktg_campaigns
             SET status = 'sending'
             WHERE status = 'scheduled'
               AND scheduled_at IS NOT NULL
               AND scheduled_at <= NOW()"
        );
        $activatedStmt->execute();
        $activatedCount = $activatedStmt->rowCount();

        // Hydrate send log for any newly activated campaigns
        if ($activatedCount > 0) {
            $stmtCamp = $db->query("SELECT id, list_id, tenant_id FROM mktg_campaigns WHERE status = 'sending'");
            $sendingCampaigns = $stmtCamp->fetchAll();
            foreach ($sendingCampaigns as $camp) {
                $stmtCheck = $db->prepare("SELECT COUNT(*) FROM mktg_send_log WHERE campaign_id = ?");
                $stmtCheck->execute([$camp['id']]);
                if ((int)$stmtCheck->fetchColumn() === 0) {
                    $repo->hydrateSendLog((int)$camp['id'], (int)$camp['list_id'], (int)$camp['tenant_id']);
                }
            }
        }

        // If there are still more emails pending in the send_log, queue another batch
        $stmt = $db->query("SELECT COUNT(*) FROM mktg_send_log WHERE status = 'queued'");
        $count = (int) $stmt->fetchColumn();

        if ($count > 0) {
            if (getenv('MAIL_QUEUE') === 'false') {
                // Modo Sincrónico: procesamos todos los lotes restantes en bucle en el mismo request
                while ($count > 0) {
                    $service->processBatch();
                    $stmt = $db->query("SELECT COUNT(*) FROM mktg_send_log WHERE status = 'queued'");
                    $count = (int) $stmt->fetchColumn();
                }

                // Limpieza final de campañas completadas
                $db->exec(
                    "UPDATE mktg_campaigns c
                     SET c.status = 'sent', c.sent_at = NOW()
                     WHERE c.status = 'sending'
                       AND NOT EXISTS (
                           SELECT 1 FROM mktg_send_log sl
                           WHERE sl.campaign_id = c.id
                             AND sl.status IN ('queued', 'processing')
                       )"
                );
            } else {
                Queue::push(self::class, []);
            }
        }
    }
}
