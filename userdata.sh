#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2 mysql-server php php-mysql

# Downloading and extracting WordPress

sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
sudo rm -rf /var/www/html/*
sudo mv wordpress/* /var/www/html/

# Configuring MySQL database

sudo mysql -u root -e "CREATE DATABASE wordpress"
sudo mysql -u root -e "CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'password'"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost'"
sudo mysql -u root -e "FLUSH PRIVILEGES"

# Wordpress Setup

cd /var/www/html/
sudo cp wp-config-sample.php wp-config.php
sudo sed -i "s/database_name_here/wordpress/g" wp-config.php
sudo sed -i "s/username_here/wordpressuser/g" wp-config.php
sudo sed -i "s/password_here/password/g" wp-config.php
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# Restarting Apache

sudo systemctl restart apache2