<?php
$db = new PDO('mysql:host=localhost;dbname=datawyrd', 'root', '');
print_r($db->query("DESCRIBE mktg_contacts")->fetchAll(PDO::FETCH_ASSOC));
