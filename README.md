

# Laravel Deployment Script for ISPConfig Managed VPS
Deploying a Laravel project to a live server often requires a series of repetitive steps to ensure the project works as expected. This script simplifies the deployment process and can either serve as a complete solution for most Laravel projects or act as a foundation for customization based on a project's specific needs.

# Prerequisites
Before proceeding, ensure the following:
1. You have already set up the user and domain for your project using the ISPConfig web panel.
2. [OPTIONAL] You have cloned your Laravel project into the appropriate web folder.

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
### 3. Download the Deployment Script
Navigate to the private folder within your user's directory and download the deployment script:
```bash
cd /var/www/clients/client45/web55/private
wget https://raw.githubusercontent.com/YiannisBourkelis/laravel-deploy-ispconfig/refs/heads/main/deploy.sh
```
### 4. Edit the Script
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
**Generating a GitHub Fine-Grained Token:**

When creating a fine-grained personal access token for the project, ensure it has only the minimum required permissions:

-   **Content**: Read-only
-   **Metadata**: Read-only

This minimizes security risks by granting the token only the access it needs to deploy your project.
### 5. Set Execute Permissions
Grant execute permissions to the script:
```bash
chmod +x deploy.sh
```
### 6. Deploy Your Project
Run the script to deploy your project:
```bash
./deploy.sh
```
If the web directory is empty, the script will:

1.  Clone your project repository.
2.  Initialize the project with an  `.env`  file.

At this point, you will be prompted to provide the contents of the  `.env`  file. Copy and paste your  `.env`  settings into the terminal, then press  **Enter**  followed by  **Ctrl+D**  (or  **Command+D**  on Mac) to save it.

A typical production  `.env`  file usually begins with:
 ```bash
 APP_NAME=your-app-name
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_TIMEZONE=UTC
APP_URL=https://your-app-url.com 
```
**Note:**  Leave the  `APP_KEY`  value empty so the script can generate the application key automatically.



Watch as your Laravel project is deployed to your server seamlessly!

You can use this script in the future whenever you need to deploy updates to your project. Simply run `./deploy.sh` again, and it will handle the deployment process for you.

### 7. [OPTIONAL] Set Correct File Permissions
If the project was already cloned inside the web directory, ensure that all files are owned by the correct user and group. You can do this by running:
```bash
sudo chown -R web55:client45 "/var/www/clients/client45/web55/web"
```
This step ensures that your project has the proper permissions for smooth operation.

# Disclaimer
This script is provided "as is," without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and noninfringement. Use it at your own risk. The author is not responsible for any damage, data loss, or other issues caused by the use or misuse of this script. Always test it in a safe environment before deploying to a live server.
