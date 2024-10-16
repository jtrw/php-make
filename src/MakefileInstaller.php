<?php

namespace Jtrw\Make;

class MakefileInstaller
{
    public static function install()
    {
        $source = __DIR__ . '/../Makefile_Template.mk';
        $destination = getcwd() . '/Makefile';
        
        if (!file_exists($destination)) {
            if (copy($source, $destination)) {
                echo "Makefile successfully copied to project root.\n";
            } else {
                echo "Failed to copy Makefile.\n";
            }
        } else {
            echo "Makefile already exists in the project root. Skipping copy.\n";
        }
    }
}
