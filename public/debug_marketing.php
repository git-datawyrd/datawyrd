<?php
require_once __DIR__ . '/../Core/bootstrap.php';

$campaignId = isset($_GET['campaign_id']) ? (int)$_GET['campaign_id'] : 0;
if (!$campaignId) {
    die("Provee un campaign_id, ej: ?campaign_id=3");
}

$db = \Core\Database::getInstance()->getConnection();

echo "<h2>Debug Campaign ID {$campaignId}</h2>";
echo "<pre>";

// 1. Check campaign
$stmt = $db->prepare("SELECT * FROM mktg_campaigns WHERE id = ?");
$stmt->execute([$campaignId]);
$campaign = $stmt->fetch();

if (!$campaign) {
    die("Campaign no existe.");
}
print_r($campaign);

$listId = $campaign['list_id'];
$tenantId = $campaign['tenant_id'];

// 2. Count total contacts in list
$stmt = $db->prepare("SELECT COUNT(*) FROM mktg_contacts WHERE list_id = ?");
$stmt->execute([$listId]);
$total = $stmt->fetchColumn();
echo "\nContactos totales en la lista {$listId}: {$total}\n";

// 3. Count contacts that match exactly the INSERT conditions
$sql = "SELECT COUNT(*)
        FROM mktg_contacts c
        WHERE c.list_id = ?
          AND c.tenant_id = ?
          AND c.status = 'subscribed'
          AND c.deleted_at IS NULL
          AND NOT EXISTS (SELECT 1 FROM blacklist b WHERE b.email = c.email)";

$stmt = $db->prepare($sql);
$stmt->execute([$listId, $tenantId]);
$eligible = $stmt->fetchColumn();
echo "Contactos elegibles para envío (subscribed, no borrados, no blacklist, tenant ok): {$eligible}\n";

if ($eligible == 0) {
    echo "\nPosibles razones de por qué es 0:\n";
    
    $stmt = $db->prepare("SELECT status, tenant_id, deleted_at, COUNT(*) as c FROM mktg_contacts WHERE list_id = ? GROUP BY status, tenant_id, deleted_at");
    $stmt->execute([$listId]);
    $stats = $stmt->fetchAll();
    echo "Distribución de contactos reales en esa lista:\n";
    print_r($stats);
}

echo "</pre>";
