<?php
require 'Core/bootstrap.php';
$db = Core\Database::getInstance()->getConnection();
$stmt = $db->query("SHOW CREATE TABLE invoice_events");
print_r($stmt->fetch(\PDO::FETCH_ASSOC));
