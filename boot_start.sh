#!/bin/sh

echo "DOCKWARE's boot_start.sh: creating or updating .env..."

ENV_PATH="$PWD/.env"

ENV_VARIABLES="# Generated for localhost by Docker's boot_start.sh...
PROJECT_NAME=$PROJECT_NAME
APP_DEBUG=1
APP_ENV=dev
APP_URL=http://$PROJECT_NAME.local
SHOP_DOMAIN=$PROJECT_NAME.local
DATABASE_URL=mysql://root:root@db:3306/shopware
DISABLE_ADMIN_COMPILATION_TYPECHECK=1
LOCK_DSN=flock
NODE_VERSION=v20
NVM_VERSION=v0.39.0
PROJECT_ENVIRONMENT_TYPE=development
ENVIRONMENT=dev
REDIS_CACHE_DATABASE=0
REDIS_SESSION_DATABASE=2
SHOPWARE_ADMIN_BUILD_ONLY_EXTENSIONS=1
OPENSEARCH_URL=http://elasticsearch:9200
SHOPWARE_ES_ENABLED=0
SHOPWARE_ES_INDEXING_ENABLED=0
SHOPWARE_ES_INDEX_PREFIX=sw6
SHOPWARE_ES_THROW_EXCEPTION=1
SHOPWARE_HTTP_CACHE_ENABLED=1
STOREFRONT_PROXY_PORT=9998
STOREFRONT_ASSETS_PORT=9999
STOREFRONT_PROXY_URL=http://$PROJECT_NAME.local
PROXY_URL=http://$PROJECT_NAME.local
BLUE_GREEN_DEPLOYMENT=0
PHP_VERSION=8.3
XDEBUG_ENABLED=1
SW_CURRENCY=GBP
APACHE_DOCROOT=/var/www/html/public
XDEBUG_MODE=debug
XDEBUG_SESSION=1
DEVELOP_AUTH_ENABLED=0
SSH_USER=sshsw6user
SSH_PWD=sshsw6secret
TIDEWAYS_KEY=xxx
TIDEWAYS_ENV=dev
"

# Always write the environment variables to the .env file, overriding if exists
printf "%s" "$ENV_VARIABLES" > "$ENV_PATH"

# Check if .env file successfully handled
if [ ! -f "$ENV_PATH" ]; then
    echo "The .env file at $ENV_PATH does not exist. Something went wrong with creating/appending..."
    exit 1
fi

# Command to be used for exporting .env vals
CMD="export \$(grep -v '^#' $ENV_PATH | xargs)"

# export for the current bash session
eval "$CMD"

# Check if .bashrc exists in the current directory, create if not
if [ ! -f "$PWD/.bashrc" ]; then
    touch "$PWD/.bashrc"
fi

# Check if the command is already in .bashrc, append if not
if ! grep -Fxq "$CMD" "$PWD/.bashrc"; then
    echo "$CMD" >> "$PWD/.bashrc"
fi

echo "\nContents of $ENV_PATH:\n\n"
cat "$ENV_PATH"
echo "-----------------------------------------------------------"

echo "DOCKWARE's boot_start.sh: composer actions..."
# Update composer
export COMPOSER_HOME="$PWD/var/cache/composer"
cd $PWD || return
sudo composer self-update --no-interaction
composer update --no-interaction
echo "-----------------------------------------------------------"
