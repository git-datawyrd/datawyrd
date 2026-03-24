<?php
/**
 * Diagnostic Script for RRHH OTP
 */
require_once __DIR__ . '/../config/env.php';
define('BASE_PATH', dirname(__DIR__));
require_once BASE_PATH . '/vendor/autoload.php';

use Core\Config;
use Core\Database;
use App\Models\Candidate;
use App\Models\JobApplication;

header('Content-Type: text/plain');

try {
    EnvLoader::load(BASE_PATH . '/.env');
    Config::load();
    
    echo "Diagnostic Data Wyrd RRHH\n";
    echo "-------------------------\n";
    echo "Environment: " . getenv('ENVIRONMENT') . "\n";
    echo "PHP Version: " . PHP_VERSION . "\n";
    
    $db = Database::getInstance()->getConnection();
    echo "Database: OK\n";
    
    // Check tables
    $tables = $db->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
    $required = ['candidates', 'job_applications', 'candidate_update_tokens'];
    foreach ($required as $t) {
        echo "Table $t: " . (in_array($t, $tables) ? 'EXISTS' : 'MISSING') . "\n";
    }
    
    // Test model instantiation
    try {
        $c = new Candidate();
        echo "Candidate Model: OK\n";
    } catch (\Throwable $e) { echo "Candidate Model: FAIL (" . $e->getMessage() . ")\n"; }
    
    try {
        $ja = new JobApplication();
        echo "JobApplication Model: OK\n";
    } catch (\Throwable $e) { echo "JobApplication Model: FAIL (" . $e->getMessage() . ")\n"; }
    
    echo "-------------------------\n";
    echo "Check CVS folder permissions:\n";
    $cvsDir = BASE_PATH . '/storage/cvs';
    if (!file_exists($cvsDir)) {
        echo "Directory storage/cvs: MISSING\n";
    } else {
        echo "Directory storage/cvs: EXISTS\n";
        echo "Writable: " . (is_writable($cvsDir) ? 'YES' : 'NO') . "\n";
    }
    
} catch (\Throwable $e) {
    echo "FATAL DIAGNOSTIC ERROR: " . $e->getMessage() . "\n";
    echo $e->getTraceAsString();
}
