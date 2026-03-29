<?php
namespace App\Services;

class AIService
{
    private $apiKey;
    private $model;
    private $endpoint;
    private $provider;

    public function __construct()
    {
        // Support for new AI_ prefix, fallback to OPENAI_ prefix for legacy compatibility
        $this->apiKey = $_ENV['AI_API_KEY'] ?? $_ENV['OPENAI_API_KEY'] ?? null;
        $this->model = $_ENV['AI_MODEL'] ?? $_ENV['OPENAI_MODEL'] ?? 'gpt-4o-mini';
        $this->provider = strtolower($_ENV['AI_PROVIDER'] ?? 'openai');
        
        if ($this->provider === 'groq') {
            $this->endpoint = 'https://api.groq.com/openai/v1/chat/completions';
        } else {
            $this->endpoint = 'https://api.openai.com/v1/chat/completions';
        }
    }

    public function isEnabled(): bool
    {
        return !empty($this->apiKey);
    }

    private function query(array $messages, float $temperature = 0.7)
    {
        if (!$this->isEnabled()) {
            return ['error' => 'API Key de IA no configurada'];
        }

        $data = [
            'model' => $this->model,
            'messages' => $messages,
            'temperature' => $temperature,
        ];

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $this->endpoint);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'Authorization: Bearer ' . $this->apiKey
        ]);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($httpCode >= 400 || !$response) {
            error_log("AI API Error ({$this->provider}): HTTP " . $httpCode . " Response: " . $response);
            return ['error' => "Error al contactar con la API ({$this->provider}). Código: " . $httpCode];
        }

        $result = json_decode($response, true);
        return $result['choices'][0]['message']['content'] ?? null;
    }

    /**

     * E11-006: GAI-01 - Genera un sumario del caso basado en el historial del chat
     */
    public function generateTicketSummary(array $messages): ?string
    {
        $context = "Resume muy brevemente los siguientes mensajes de un ticket de soporte de manera ejecutiva y estructurada (Problema, Acciones Tomadas, Pendientes):\n\n";
        foreach ($messages as $msg) {
            $role = !empty($msg['is_admin']) ? 'Staff' : 'Cliente';
            $date = $msg['created_at'] ?? '';
            $msgContent = $msg['message'] ?? '';
            $context .= "{$role} ({$date}): {$msgContent}\n";
        }

        $prompt = [
            ['role' => 'system', 'content' => 'Eres un asistente experto en soporte técnico B2B, encargado de resumir tickets complejos para handoff entre analistas. Devuelve solo el resumen en Markdown usando tres secciones: **Problema**, **Acciones Tomadas** y **Pendientes**.'],
            ['role' => 'user', 'content' => $context]
        ];

        $result = $this->query($prompt, 0.3);
        return is_array($result) && isset($result['error']) ? null : trim($result);
    }

    /**
     * E11-007: GAI-02 - Extrae items de acción
     */
    public function extractActionItems(string $description): ?array
    {
        $prompt = [
            ['role' => 'system', 'content' => 'Eres un Technical Project Manager. Extrae una lista de tareas (action items) accionables a partir del requerimiento inicial de un cliente. Devuelve ÚNICAMENTE un JSON array válido de strings (ej: ["Configurar BD", "Revisar logs"]), sin explicaciones ni markdown extra.'],
            ['role' => 'user', 'content' => "Requerimiento: {$description}"]
        ];

        $result = $this->query($prompt, 0.2);
        if (is_array($result) && isset($result['error'])) {
            return null;
        }

        $result = preg_replace('/```json|```/', '', $result);
        $items = json_decode(trim($result), true);
        
        return is_array($items) ? $items : null;
    }

    /**
     * E11-008: GAI-03 - Reescribe borrador a tono formal/ejecutivo
     */
    public function rewriteDraft(string $draft, string $tone = 'formal y profesional'): ?string
    {
        $prompt = [
            ['role' => 'system', 'content' => "Eres un asistente de redacción para ejecutivos de soporte técnico. Debes reescribir el borrador del usuario con un tono {$tone}, directo y al punto."],
            ['role' => 'user', 'content' => $draft]
        ];

        $result = $this->query($prompt, 0.4);
        return is_array($result) && isset($result['error']) ? null : trim($result);
    }

    /**
     * E11-009: GAI-04 - Genera respuesta automática inicial políglota
     */
    public function generateAutoResponse(string $subject, string $description, string $locale = 'es'): ?string
    {
        $languageName = ($locale === 'en') ? 'English' : 'Spanish';
        $instructions = ($locale === 'en') 
            ? "You are 'Data Wyrd Bot'. Provide an empathetic and professional initial response in English. Confirm you understood the issue briefly and state the technical team will review it. Keep it under 3 paragraphs."
            : "Eres el 'Data Wyrd Bot'. Da una primera respuesta empática y profesional en Español. Confirma que entendiste el problema brevemente y que el equipo técnico lo revisará pronto. Máximo 3 párrafos.";

        $prompt = [
            ['role' => 'system', 'content' => $instructions],
            ['role' => 'user', 'content' => "Subject: {$subject}\nDescription: {$description}"]
        ];

        $result = $this->query($prompt, 0.6);
        return is_array($result) && isset($result['error']) ? null : trim($result);
    }
}
