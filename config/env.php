<?php
/**
 * Loader Explícito de .env (Legacy Wrapper)
 * Mantiene compatibilidad con código que no usa namespaces.
 */
require_once __DIR__ . '/../Core/EnvLoader.php';

if (!class_exists('EnvLoader')) {
    class_alias('Core\EnvLoader', 'EnvLoader');
}
