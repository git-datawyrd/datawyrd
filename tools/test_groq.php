<?php
require 'Core/bootstrap.php';

$ai = new \App\Services\AIService();

if (!$ai->isEnabled()) {
    echo "AI no está habilitada.\n";
    exit;
}

$start = microtime(true);
echo "Enviando prompt a Groq (Llama 3)...\n";
$messages = [
    ['role' => 'system', 'content' => 'Sos un asistente útil.'],
    ['role' => 'user', 'content' => 'Hola, ¿qué modelo eres y de qué proveedor vienes? ¡Responde en 1 frase corta!']
];

// Using reflection to test private query method
$reflector = new ReflectionClass(get_class($ai));
$method = $reflector->getMethod('query');
$method->setAccessible(true);
$response = $method->invokeArgs($ai, [$messages, 0.7]);

$end = microtime(true);

echo "------\n";
if (is_array($response)) {
    print_r($response);
} else {
    echo $response . "\n";
}
echo "------\n";
echo "Tiempo de respuesta: " . round($end - $start, 2) . " segundos\n";
