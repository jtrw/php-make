<?php

namespace Jtrw\Make;

use Composer\Composer;
use Composer\IO\IOInterface;
use Composer\Script\Event;
use Composer\Plugin\PluginInterface;

class MakefilePlugin implements PluginInterface
{
    public static function installMakefile(Event $event)
    {
        $source = __DIR__ . '/../Makefile_Template.mk';
        $destination = getcwd() . '/Makefile';
        
        if (!file_exists($destination)) {
            if (copy($source, $destination)) {
                echo "Makefile successfully copied to the project root.\n";
            } else {
                echo "Failed to copy Makefile.\n";
            }
        } else {
            echo "Makefile already exists. Skipping copy.\n";
        }
    }
    
    public function activate(Composer $composer, IOInterface $io)
    {
        // TODO: Implement activate() method.
    }
    
    public function deactivate(Composer $composer, IOInterface $io)
    {
        // TODO: Implement deactivate() method.
    }
    
    public function uninstall(Composer $composer, IOInterface $io)
    {
        // TODO: Implement uninstall() method.
    }
}
