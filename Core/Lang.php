<?php
namespace Core;

/**
 * Lang - Internationalization Engine (v12.0)
 * Handles JSON-based translations from resources/lang/
 */
class Lang
{
    private static array $dictionaries = [];
    private static string $locale = 'es';

    /**
     * Load the current locale dictionary.
     */
    public static function load(): void
    {
        self::$locale = Session::get('locale', Config::get('app.locale', 'es'));
        self::ensureDictionaryLoaded(self::$locale);
    }

    /**
     * Ensure a specific locale dictionary is in memory.
     */
    private static function ensureDictionaryLoaded(string $locale): void
    {
        if (isset(self::$dictionaries[$locale])) return;

        $path = BASE_PATH . "/resources/lang/" . $locale . ".json";
        if (file_exists($path)) {
            $json = file_get_contents($path);
            self::$dictionaries[$locale] = json_decode($json, true) ?? [];
        } else {
            error_log("I18N Error: Translation file not found for " . $locale);
            self::$dictionaries[$locale] = [];
        }
    }

    /**
     * Get a translation by key. Support for dot.notation.
     * 
     * @param string $key e.g., 'auth.login_failed'
     * @param array $replacements e.g., ['name' => 'User']
     * @param string|null $locale System will use current locale if null
     */
    public static function get(string $key, array $replacements = [], ?string $locale = null): string
    {
        $targetLocale = $locale ?? self::$locale;
        self::ensureDictionaryLoaded($targetLocale);

        $parts = explode('.', $key);
        $result = self::$dictionaries[$targetLocale];

        foreach ($parts as $part) {
            if (isset($result[$part])) {
                $result = $result[$part];
            } else {
                return $key; // Return key if not found
            }
        }

        if (!is_string($result)) {
            return $key;
        }

        foreach ($replacements as $search => $replace) {
            $result = str_replace(':' . $search, (string)$replace, $result);
        }

        return $result;
    }

    /**
     * Change the system locale.
     */
    public static function setLocale(string $locale): void
    {
        self::ensureDictionaryLoaded($locale);
        self::$locale = $locale;
        Session::set('locale', $locale);
    }

    public static function getLocale(): string
    {
        return self::$locale;
    }
}
