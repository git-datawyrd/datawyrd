<?php
namespace Core\Console;

class Kernel
{
    private array $commands = [
        'migrate' => 'migrate.php',
        'worker'  => 'worker.php',
        'diag'    => 'validate_prd.php',
        'sync'    => 'sync_schema.php',
        'test-di' => 'test_di.php'
    ];

    public function handle(array $args): int
    {
        $command = $args[1] ?? 'help';
        
        switch ($command) {
            case 'migrate':
            case 'worker':
            case 'diag':
            case 'sync':
            case 'test-di':
                echo "\e[32m[DW-OS] Executing " . strtoupper($command) . "...\e[0m\n";
                // En un entorno profesional dispararía comandos aislados, 
                // aquí incluimos los scripts existentes mapeados en $commands.
                include __DIR__ . '/../../tools/' . $this->commands[$command];
                return 0;
            case 'help':
            default:
                echo "\e[34mData Wyrd OS - CLI Console Interface 11.5.0\e[0m\n";
                echo "------------------------------------------\n";
                echo "Usage:\n";
                echo "  php bin/console <command>\n\n";
                echo "Available Commands:\n";
                echo "  migrate  - Run pending structural migrations\n";
                echo "  sync     - Synchronize local schema with production references\n";
                echo "  worker   - Start the background task worker (Redis/MySQL based)\n";
                echo "  diag     - Performance and security diagnostic audit\n";
                echo "  test-di  - Validate Container dependency health\n";
                return 0;
        }
    }
}
