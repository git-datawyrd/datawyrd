<?php
try {
    $db = new PDO('mysql:host=localhost;dbname=datawyrd', 'root', '');
    $stmt = $db->prepare('SELECT * FROM tickets WHERE subject = ? ORDER BY created_at DESC LIMIT 1');
    $stmt->execute(['Prueba de Flujo UX Fase 1']);
    $t = $stmt->fetch(PDO::FETCH_ASSOC);
    if ($t) {
        echo "TICKET_FOUND: " . $t['ticket_number'] . "\n";
        echo "CLIENT_ID: " . $t['client_id'] . "\n";

        $stmt = $db->prepare('SELECT * FROM users WHERE id = ?');
        $stmt->execute([$t['client_id']]);
        $u = $stmt->fetch(PDO::FETCH_ASSOC);
        if ($u) {
            echo "USER_FOUND: " . $u['email'] . "\n";
        }
    } else {
        echo "TICKET_NOT_FOUND\n";
    }
} catch (Exception $e) {
    echo $e->getMessage();
}
