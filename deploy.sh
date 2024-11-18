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
GITHUB_USERNAME="YiannisBourkelis"
GITHUB_TOKEN="github_pat_your_github_token"
REPO_OWNER="YiannisBourkelis"
REPO_NAME="your-laravel-repo-name"

if [ "$(whoami)" != "$USER" ]; then
  echo "Error: This script must be run as user '$USER'."
  exit 1
fi

# Proceed with the rest of the script
echo "Running script as user 'web14'..."

echo "Change to the project directory"
cd $APP_DIR

echo "Turn on maintenance mode"
/usr/bin/php$PHP_VERSION artisan down --render="maintenance" --retry=30 || true
#/usr/bin/php$PHP_VERSION artisan down --retry=30 || true

echo "Pull the latest changes from the git repository $BRANCH..."
# git reset --hard
# git clean -df
# sudo -u $USER git pull origin $BRANCH
git pull --no-rebase https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$REPO_OWNER/$REPO_NAME.git $BRANCH

echo "Install/update composer dependecies"
/usr/bin/php$PHP_VERSION /usr/local/bin/composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

echo "Run database migrations"
/usr/bin/php$PHP_VERSION artisan migrate --force
# /usr/bin/php$PHP_VERSION artisan migrate

echo "Clear caches"
/usr/bin/php$PHP_VERSION artisan optimize:clear

# Clear expired password reset tokens
/usr/bin/php$PHP_VERSION artisan auth:clear-resets

# Install node modules
npm ci

# Build assets using Laravel Mix
npm run build

echo "cache optimize"
/usr/bin/php$PHP_VERSION artisan optimize

# Turn off maintenance mode
/usr/bin/php$PHP_VERSION artisan up
