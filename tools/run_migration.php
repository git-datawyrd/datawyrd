<?php
try {
    $db = new PDO('mysql:host=localhost;dbname=datawyrd', 'root', '');
    $sql = file_get_contents('database/migrations/01_add_request_id_to_audit.sql');
    $db->exec($sql);
    echo "Migration successful";
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
