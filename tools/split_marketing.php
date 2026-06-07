<?php
$classFile = realpath(__DIR__ . '/../App/Controllers/Admin/MarketingController.php');
require_once __DIR__ . '/../Core/Controller.php';
require_once $classFile;

$ref = new ReflectionClass('\App\Controllers\Admin\MarketingController');
$lines = file($classFile);

// Group methods
$campaignMethods = ['campaigns', 'createCampaign', 'storeCampaign', 'showCampaign', 'launchCampaign', 'pauseCampaign', 'deleteCampaign', 'duplicateCampaign', 'updateCampaign'];
$listMethods = ['lists', 'showList', 'storeList', 'importContacts', 'storeContact', 'downloadCsvTemplate', 'deleteList'];
$templateMethods = ['templates', 'createTemplate', 'storeTemplate', 'editTemplate', 'updateTemplate', 'improveText', 'generateAiEmail'];
$coreMethods = ['__construct', 'index', 'analytics', 'settings', 'exportInteractions'];

function generateClass($className, $methodsToKeep, $ref, $lines) {
    $out = "<?php\nnamespace App\\Controllers\\Admin;\n\n";
    $out .= "use Core\\Controller;\nuse Core\\Database;\nuse Core\\Auth;\nuse Core\\Session;\nuse App\\Services\\MailService;\nuse PDO;\n\n";
    $out .= "class {$className} extends Controller\n{\n";
    
    // Copy the __construct to all of them if not Core, to ensure Auth checks
    if ($className !== 'MarketingController' && !in_array('__construct', $methodsToKeep)) {
        $methodsToKeep[] = '__construct';
    }

    foreach ($methodsToKeep as $m) {
        if ($ref->hasMethod($m)) {
            $method = $ref->getMethod($m);
            $start = $method->getStartLine() - 1; // 0-indexed
            $end = $method->getEndLine() - 1;
            
            // grab docblock if exists
            $doc = $method->getDocComment();
            if ($doc) {
                // Find where the docblock starts
                for($i = $start - 1; $i >= 0; $i--) {
                    if (strpos($lines[$i], '/**') !== false) {
                        $out .= implode("", array_slice($lines, $i, $start - $i));
                        break;
                    }
                }
            }
            
            $out .= implode("", array_slice($lines, $start, $end - $start + 1)) . "\n\n";
        }
    }
    
    $out .= "}\n";
    return $out;
}

$campaignClass = generateClass('MarketingCampaignController', $campaignMethods, $ref, $lines);
$listClass = generateClass('MarketingListController', $listMethods, $ref, $lines);
$templateClass = generateClass('MarketingTemplateController', $templateMethods, $ref, $lines);
$coreClass = generateClass('MarketingController', $coreMethods, $ref, $lines);

file_put_contents(__DIR__ . '/../App/Controllers/Admin/MarketingCampaignController.php', $campaignClass);
file_put_contents(__DIR__ . '/../App/Controllers/Admin/MarketingListController.php', $listClass);
file_put_contents(__DIR__ . '/../App/Controllers/Admin/MarketingTemplateController.php', $templateClass);
file_put_contents(__DIR__ . '/../App/Controllers/Admin/MarketingController.php', $coreClass);

echo "Splitting completed.\n";
