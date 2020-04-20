#!/bin/bash

file=./.installed
echo "Start"
if [ ! -e "$file" ]; then
    echo "Installing server"
    composer install
    php bin/console doctrine:schema:update --force
    php bin/console cache:clear
    php bin/console assets:install
    php bin/console translation:update --dump-messages --force pl AppBundle
    touch $file
    echo "Data successfully installed"
fi

# Start server
echo "Starting server"
php bin/console server:run 0.0.0.0:8000
