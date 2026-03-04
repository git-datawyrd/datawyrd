<?php

namespace Core;

/**
 * ApiRouter - Specialized router for /api/v1 endpoints.
 * Returns only JSON responses.
 */
class ApiRouter
{
    protected string $version = 'v1';
    protected Container $container;

    public function __construct(Container $container)
    {
        $this->container = $container;
    }

    public function handle(array $url): void
    {
        // Sample URL: ['api', 'v1', 'auth', 'login']
        if (!isset($url[1]) || $url[1] !== $this->version) {
            $this->jsonError("API Version mismatch. Expected {$this->version}", 400);
        }

        if (!isset($url[2])) {
            $this->jsonError("API Endpoint missing", 404);
        }

        $controllerName = ucfirst($url[2]) . 'Controller';
        $fullControllerPath = "\\App\\Controllers\\Api\\" . $controllerName;

        if (!class_exists($fullControllerPath)) {
            $this->jsonError("API Controller {$controllerName} not found", 404);
        }

        $controller = $this->container->get($fullControllerPath);
        $method = $url[3] ?? 'index';

        if (!method_exists($controller, $method)) {
            $this->jsonError("API Method {$method} not found", 404);
        }

        $params = array_slice($url, 4);

        try {
            // Run the controller method using the container to support method DI
            $this->container->call($controller, $method, $params);
        } catch (\Exception $e) {
            SecurityLogger::log('API_ERROR', $e->getMessage(), 'ERROR');
            $this->jsonError("Internal Server Error: " . $e->getMessage(), 500);
        }
    }

    private function jsonError(string $message, int $code = 400): void
    {
        http_response_code($code);
        header('Content-Type: application/json');
        echo json_encode(['success' => false, 'error' => $message]);
        exit;
    }
}
