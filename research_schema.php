<?php
$db = new PDO('mysql:host=localhost;dbname=datawyrd','root','');
$r = $db->query("SHOW COLUMNS FROM chat_messages LIKE 'user_id'")->fetch(PDO::FETCH_ASSOC);
echo "chat_messages.user_id => Null: {$r['Null']}, Key: {$r['Key']}, Default: {$r['Default']}\n";

// Also verify the constraint name
$fk = $db->query("SELECT CONSTRAINT_NAME FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA='datawyrd' AND TABLE_NAME='chat_messages' AND COLUMN_NAME='user_id'")->fetch(PDO::FETCH_ASSOC);
echo "FK: " . ($fk ? $fk['CONSTRAINT_NAME'] : 'NONE') . "\n";
