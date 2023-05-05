#!/bin/bash
sudo apt-get update
sudo apt-get install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
sudo apt-get install mysql-server php libapache2-mod-php php-mysql -y
sudo systemctl start mysql
sudo systemctl enable mysql
sudo mysql -u root -e \"CREATE DATABASE wordpress\"
sudo mysql -u root -e \"GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password'\"
sudo mysql -u root -e \"FLUSH PRIVILEGES\"
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xvzf latest.tar.gz
sudo mv wordpress /var/www/html/
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/wordpress.conf
sudo sed -i 's/DocumentRoot\ \/var\/www\/html/DocumentRoot\ \/var\/www\/html\/wordpress/g' /etc/apache2/sites-available/wordpress.conf
sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/d' /etc/apache2/sites-available/wordpress.conf
sudo sed -i 's/#ServerName\ www\.example\.com/ServerName\ example\.com/g' /etc/apache2/sites-available/wordpress.conf
sudo sed -i 's/#ServerAlias\ www\.example\.com/ServerAlias\ www\.example\.com/g' /etc/apache2/sites-available/wordpress.conf
sudo sed -i 's/AllowOverride\ None/AllowOverride\ All/g' /etc/apache2/apache2.conf
sudo rm rf etc/apache2/sites-available/000-default.conf
sudo a2enmod rewrite
sudo a2ensite wordpress.conf
sudo systemctl restart apache2