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

        $result = $service->processBatch();

        // If there are still more emails pending in the send_log, queue another batch
        $stmt = $db->query("SELECT COUNT(*) FROM mktg_send_log WHERE status = 'queued'");
        $count = (int) $stmt->fetchColumn();

        if ($count > 0) {
            Queue::push(self::class, []);
        }
    }
}
