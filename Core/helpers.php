<?php
/**
 * Global Helpers for Data Wyrd OS
 */

if (!function_exists('__')) {
    /**
     * Translate the given message.
     * 
     * @param string $key
     * @param array $replacements
     * @return string
     */
    function __(string $key, array $replacements = []): string
    {
        return \Core\Lang::get($key, $replacements);
    }
}

if (!function_exists('app_locale')) {
    /**
     * Get the current application locale.
     * 
     * @return string
     */
    function app_locale(): string
    {
        return \Core\Lang::getLocale();
    }
}
