<?php


$source = __DIR__.'/../Makefile_Template.mk';
$destination = getcwd().'/Makefile';

echo "Copying Makefile to the project root...\n";
echo "Source: $source\n";
echo "Destination: $destination\n";

if (!file_exists($destination)) {
    if (copy($source, $destination)) {
        echo "Makefile successfully copied to the project root.\n";
    } else {
        echo "Failed to copy Makefile. Check permissions or paths.\n";
    }
} else {
    echo "Makefile already exists in the project root. Skipping copy.\n";
}
