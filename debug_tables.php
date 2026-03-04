<?php
$db = new PDO('mysql:host=localhost;dbname=datawyrd', 'root', '');
$stmt = $db->query('DESCRIBE audit_logs');
print_r($stmt->fetchAll(PDO::FETCH_ASSOC));
