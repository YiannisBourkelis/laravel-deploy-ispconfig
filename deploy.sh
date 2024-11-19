#!/bin/bash

# Laravel Deployment Script for ISPConfig-Managed VPS
# Author: Yiannis Bourkelis
# Repository: https://github.com/YiannisBourkelis/laravel-deploy-ispconfig/
# License: MIT License (https://github.com/YiannisBourkelis/laravel-deploy-ispconfig/blob/main/LICENSE)
#
# Disclaimer:
# This script is provided "as is", without warranty of any kind, express or implied, including but not limited to
# the warranties of merchantability, fitness for a particular purpose, and noninfringement. In no event shall the
# authors or copyright holders be liable for any claim, damages, or other liability, whether in an action of
# contract, tort, or otherwise, arising from, out of, or in connection with the script or the use or other
# dealings in the script. Use this script at your own risk.

# Define variables
APP_DIR="/var/www/your-domain.com/web/your-laravel-project-folder"
BRANCH="main"
PHP_VERSION="8.3"
USER="web55"
GITHUB_USERNAME="YourUserName"
GITHUB_TOKEN="github_pat_your_github_token"
REPO_OWNER="YourUserName"
REPO_NAME="your-laravel-repo-name"

# Check if the script is running as the correct user
if [ "$(whoami)" != "$USER" ]; then
  echo
  echo "============================================================"
  echo " This script should be run as user '$USER'."
  echo "============================================================"
  echo
  read -p "Do you want to switch to '$USER' and re-run the script? [y/N]: " RESPONSE
  RESPONSE=${RESPONSE,,} # Convert to lowercase
  if [[ "$RESPONSE" == "y" || "$RESPONSE" == "yes" ]]; then
    echo "Switching to user '$USER'..."
    sudo -u $USER -H bash -c "$0" # Re-run the script as $USER
    exit $? # Exit with the status of the re-executed script
  else
    echo "Exiting. Please re-run the script as user '$USER'."
    exit 1
  fi
fi

echo "Running script as user '$USER'..."

# Change to the project directory
echo "Changing to the project directory: $APP_DIR"
cd $APP_DIR || { echo "Error: Failed to change directory to $APP_DIR"; exit 1; }

# Enable maintenance mode
echo "Turning on maintenance mode"
/usr/bin/php$PHP_VERSION artisan down --retry=30 || true
#/usr/bin/php$PHP_VERSION artisan down --render="maintenance" --retry=30 || true

# Pull the latest changes from the repository
echo "Pulling the latest changes from the git repository ($BRANCH)..."
git pull --no-rebase https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$REPO_OWNER/$REPO_NAME.git $BRANCH

# Install or update composer dependencies
echo "Installing/updating composer dependencies"
/usr/bin/php$PHP_VERSION /usr/local/bin/composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

# Run database migrations
echo "Running database migrations"
/usr/bin/php$PHP_VERSION artisan migrate --force

# Clear caches
echo "Clearing caches"
/usr/bin/php$PHP_VERSION artisan optimize:clear

# Clear expired password reset tokens
echo "Clearing expired password reset tokens"
/usr/bin/php$PHP_VERSION artisan auth:clear-resets

# Install node modules
echo "Installing node modules"
npm ci

# Build assets using Laravel Mix
echo "Building assets using Laravel Mix"
npm run build

# Optimize application cache
echo "Optimizing application cache"
/usr/bin/php$PHP_VERSION artisan optimize

# Disable maintenance mode
echo "Turning off maintenance mode"
/usr/bin/php$PHP_VERSION artisan up

echo "Deployment script completed successfully!"