#!/bin/bash

# OUTPUT VARS
export TERM=xterm
green=`tput setaf 2`
yellow=`tput setaf 3`
bold=`tput bold`
reset=`tput sgr0`

echo "${yellow}Updating APT and upgrading${reset}"

# Update apt-get and upgrade
apt-get update && apt-get upgrade -y

echo "${yellow}Installing Dependencies${reset}"

# Install dependencies
apt-get install -y wget

echo "${yellow}Installing Apache Server${reset}"
# Install Apache
apt-get install -y apache2 \
        php7.4 \
        php7.4-mysql
echo "ServerName localhost" >> /etc/apache2/apache2.conf

echo "${yellow}Enable Apache Modules${reset}"
# Enable Apache modules
a2enmod rewrite

# Remove default apache html
rm /var/www/html/index.html

# Set permissions to public dir
chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

echo "${yellow}Downloading WordPress${reset}"
# Download worpress and extract on the fly to public dir
wget -qO- https://wordpress.org/latest.tar.gz | tar xvz -C /var/www/html --strip-components 1


echo "${yellow}Installing MySQL server${reset}"
# Install MySQL server
apt-get install mysql-server -y

# Start MySQL server
service mysql stop
usermod -d /var/lib/mysql/ mysql
service mysql start

# Wait MySQL server startup
echo "${yellow}Waiting for database connection...${reset}"
while ! mysqladmin ping --silent; do sleep 1; done

echo "${yellow}Setting DB credentials...${reset}"


# Create db and user
mysql -e "CREATE DATABASE ${DB_NAME} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
mysql -e "CREATE USER ${DB_USER}@localhost IDENTIFIED BY '${DB_PASSWD}';"
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"


echo "${yellow}Setting WordPress DB credentials...${reset}"

# Create WordPress config
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# Set database details with perl find and replace
perl -pi -e "s/database_name_here/$DB_NAME/g" /var/www/html/wp-config.php
perl -pi -e "s/username_here/$DB_USER/g" /var/www/html/wp-config.php
perl -pi -e "s/password_here/$DB_PASSWD/g" /var/www/html/wp-config.php

#set WP salts
perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' /var/www/html/wp-config.php