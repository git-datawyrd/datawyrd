<?php
require_once __DIR__ . '/../Core/bootstrap.php';

$db = \Core\Database::getInstance()->getConnection();

echo "<pre>";
echo "All lists:\n";
$stmt = $db->query("SELECT id, name FROM mktg_lists");
print_r($stmt->fetchAll());

echo "\nAll contacts in mktg_contacts:\n";
$stmt = $db->query("SELECT id, list_id, email, tenant_id, status FROM mktg_contacts");
print_r($stmt->fetchAll());

echo "\nEnvironment: " . getenv('ENVIRONMENT') . "\n";
echo "DB Host: " . \Core\Config::get('db.host') . "\n";
echo "DB Name: " . \Core\Config::get('db.name') . "\n";
echo "</pre>";
