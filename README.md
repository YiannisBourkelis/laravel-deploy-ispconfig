# Laravel Deployment Script for ISPConfig Managed VPS
Deploying a Laravel project to a live server often requires a series of repetitive steps to ensure the project works as expected. This script simplifies the deployment process and can either serve as a complete solution for most Laravel projects or act as a foundation for customization based on a project's specific needs.

# Prerequisites
Before proceeding, ensure the following:
1. You have already set up the user and domain for your project using the ISPConfig web panel.
2. You have cloned your Laravel project into the appropriate web folder.

# Installation Steps
### 1. Navigate to Your Project Folder
First, go to your project's web folder:
```bash
cd /var/www/yourdomain.com
```
Verify the user and group assigned by ISPConfig by running:
```bash
ls -l
```

For example, if the output shows the user as **web55** and the group as **client45**, note these values for later steps.

### 2. Enable npm Commands
To execute npm commands, you need to create an `.npm` folder inside the user’s web folder. Since the web folder is protected by default, temporarily unprotect it, create the `.npm` folder, and then protect it again:
```bash
chattr -i /var/www/clients/client45/web55/
mkdir /var/www/clients/client45/web55/.npm
sudo chown -R web55:client45 "/var/www/clients/client45/web55/.npm"
chattr +i /var/www/clients/client45/web55/
```

### 3. Set Correct File Permissions
Ensure all files within the web folder are owned by the correct user and group:
```bash
sudo chown -R web55:client45 "/var/www/clients/client45/web55/web"
```
### 4. Download the Deployment Script
Navigate to the private folder within your user's directory and download the deployment script:
```bash
cd /var/www/clients/client45/web55/private
wget https://raw.githubusercontent.com/YiannisBourkelis/laravel-deploy-ispconfig/refs/heads/main/deploy.sh
```
### 5. Edit the Script
Open the `deploy.sh` script with your favorite text editor:
```bash
vim deploy.sh
```
Modify the variables at the beginning of the script to match your project’s configuration:
```bash
APP_DIR="/var/www/your-domain.com/web/your-laravel-project-folder"
BRANCH="main"
PHP_VERSION="8.3"
USER="web55"
GITHUB_USERNAME="YourUserName"
GITHUB_TOKEN="github_pat_your_github_token"
REPO_OWNER="YourUserName"
REPO_NAME="your-laravel-repo-name"
```
### 6. Set Execute Permissions
Grant execute permissions to the script:
```bash
chmod +x deploy.sh
```
### 7. Deploy Your Project
Run the script to deploy your project:
```bash
./deploy.sh
```
Watch as your Laravel project is deployed to your server seamlessly!

You can use this script in the future whenever you need to deploy updates to your project. Simply run `./deploy.sh` again, and it will handle the deployment process for you.

# Disclaimer
This script is provided "as is," without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and noninfringement. Use it at your own risk. The author is not responsible for any damage, data loss, or other issues caused by the use or misuse of this script. Always test it in a safe environment before deploying to a live server.
