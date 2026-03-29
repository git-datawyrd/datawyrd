<?php
namespace Core;

/**
 * Input Validation and Sanitization Helper
 */
class Validator
{
    private $errors = [];
    private $data = [];

    /**
     * Validate input data
     * 
     * @param array $data Input data to validate
     * @param array $rules Validation rules
     * @return self
     */
    public function validate($data, $rules)
    {
        $this->data = $data;
        $this->errors = [];

        foreach ($rules as $field => $ruleSet) {
            $ruleList = explode('|', $ruleSet);
            $value = $data[$field] ?? null;

            foreach ($ruleList as $rule) {
                $this->applyRule($field, $value, $rule);
            }
        }

        return $this;
    }

    /**
     * Apply a single validation rule
     */
    private function applyRule($field, $value, $rule)
    {
        // Parse rule with parameters (e.g., "max:255")
        $params = [];
        if (strpos($rule, ':') !== false) {
            list($rule, $paramString) = explode(':', $rule, 2);
            $params = explode(',', $paramString);
        }

        switch ($rule) {
            case 'required':
                if (empty($value) && $value !== '0') {
                    $this->addError($field, __('validation.required', ['field' => $field]));
                }
                break;

            case 'email':
                if ($value && !filter_var($value, FILTER_VALIDATE_EMAIL)) {
                    $this->addError($field, __('validation.email', ['field' => $field]));
                }
                break;

            case 'min':
                $min = $params[0] ?? 0;
                if (strlen($value) < $min) {
                    $this->addError($field, __('validation.min', ['field' => $field, 'min' => $min]));
                }
                break;

            case 'max':
                $max = $params[0] ?? 255;
                if (strlen($value) > $max) {
                    $this->addError($field, __('validation.max', ['field' => $field, 'max' => $max]));
                }
                break;

            case 'numeric':
                if ($value && !is_numeric($value)) {
                    $this->addError($field, __('validation.numeric', ['field' => $field]));
                }
                break;

            case 'alpha':
                if ($value && !ctype_alpha(str_replace(' ', '', $value))) {
                    $this->addError($field, __('validation.alpha', ['field' => $field]));
                }
                break;

            case 'alphanumeric':
                if ($value && !ctype_alnum(str_replace(' ', '', $value))) {
                    $this->addError($field, __('validation.alphanumeric', ['field' => $field]));
                }
                break;

            case 'url':
                if ($value && !filter_var($value, FILTER_VALIDATE_URL)) {
                    $this->addError($field, __('validation.url', ['field' => $field]));
                }
                break;

            case 'in':
                if ($value && !in_array($value, $params)) {
                    $this->addError($field, __('validation.in', ['field' => $field]));
                }
                break;
        }
    }

    /**
     * Add error message
     */
    private function addError($field, $message)
    {
        if (!isset($this->errors[$field])) {
            $this->errors[$field] = [];
        }
        $this->errors[$field][] = $message;
    }

    /**
     * Check if validation passed
     */
    public function passes()
    {
        return empty($this->errors);
    }

    /**
     * Check if validation failed
     */
    public function fails()
    {
        return !$this->passes();
    }

    /**
     * Get all errors
     */
    public function errors()
    {
        return $this->errors;
    }

    /**
     * Get first error for a field
     */
    public function first($field)
    {
        return $this->errors[$field][0] ?? null;
    }

    /**
     * Sanitize string input
     */
    public static function sanitizeString($input)
    {
        return htmlspecialchars(strip_tags(trim($input)), ENT_QUOTES, 'UTF-8');
    }

    /**
     * Sanitize email
     */
    public static function sanitizeEmail($email)
    {
        return filter_var(trim($email), FILTER_SANITIZE_EMAIL);
    }

    /**
     * Sanitize URL
     */
    public static function sanitizeUrl($url)
    {
        return filter_var(trim($url), FILTER_SANITIZE_URL);
    }

    /**
     * Sanitize integer
     */
    public static function sanitizeInt($value)
    {
        return filter_var($value, FILTER_SANITIZE_NUMBER_INT);
    }

    /**
     * Generate CSRF Token
     */
    public static function generateCsrfToken()
    {
        if (!Session::has('csrf_token')) {
            Session::set('csrf_token', bin2hex(random_bytes(32)));
        }
        return Session::get('csrf_token');
    }

    /**
     * Verify CSRF Token
     */
    public static function verifyCsrfToken($token)
    {
        $sessionToken = Session::get('csrf_token');
        return $sessionToken && hash_equals($sessionToken, $token);
    }

    /**
     * Validate file upload
     */
    public static function validateFile($file, $maxSize = 10485760, $allowedExtensions = [])
    {
        $errors = [];

        if (!isset($file['error']) || is_array($file['error'])) {
            $errors[] = __('validation.file_invalid');
            return $errors;
        }

        if ($file['error'] !== UPLOAD_ERR_OK) {
            $errors[] = __('validation.file_upload_error');
            return $errors;
        }

        // 1. Validar tamaño
        if ($file['size'] > $maxSize) {
            $errors[] = __('validation.file_size');
        }

        // 2. Validar Tipo MIME Real (No solo extensión)
        $finfo = new \finfo(FILEINFO_MIME_TYPE);
        $mimeType = $finfo->file($file['tmp_name']);

        // Mapeo básico de extensiones permitidas a MIME types comunes para seguridad extra
        $mimeMap = [
            'jpg' => ['image/jpeg', 'image/jpg'],
            'jpeg' => ['image/jpeg', 'image/jpg'],
            'png' => ['image/png'],
            'gif' => ['image/gif'],
            'pdf' => ['application/pdf'],
            'zip' => ['application/zip', 'application/x-zip-compressed'],
            'doc' => ['application/msword'],
            'docx' => ['application/vnd.openxmlformats-officedocument.wordprocessingml.document'],
            'xls' => ['application/vnd.ms-excel'],
            'xlsx' => ['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']
        ];

        if (!empty($allowedExtensions)) {
            $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
            if (!in_array($ext, $allowedExtensions)) {
                $errors[] = __('validation.file_extension', ['ext' => $ext]);
            } else {
                // Verificar que el MIME coincida con la extensión esperada
                $expectedMimes = $mimeMap[$ext] ?? [];
                if (!empty($expectedMimes) && !in_array($mimeType, $expectedMimes)) {
                    $errors[] = __('validation.file_mime_mismatch');
                }
            }
        }

        return $errors;
    }

    /**
     * Generar nombre de archivo seguro (Hash + Timestamp)
     */
    public static function generateSecureFileName($originalName)
    {
        $ext = strtolower(pathinfo($originalName, PATHINFO_EXTENSION));
        return md5(uniqid(microtime(), true)) . '_' . time() . '.' . $ext;
    }
}
