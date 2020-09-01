#! /bin/bash

if [ `whoami` != 'root' ]
  then
    echo "You must be root to run this script"
    exit
else

# Variables

#############  PHP #######################
PHP_VERSION="php7.3"  #e.g: php7.1, php7.2
############  SITE DB CREDENTIALS ############
DBUSER="demouser"
DBPASSWORD="demopassword"
DBNAME="demoDB"
################# DOMAIN CONFIGURATION ##############################
DOMAIN="test.com"
######################### APACHE CONFIGURATIONS #############
SITE_USER="test"
SITE_WORKING_DIR="/home/test/"


############################### Install php #############################
sudo apt-get install python-software-properties -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update -y
sudo apt-get install -y $PHP_VERSION
sudo apt-get install -y $PHP_VERSION-mysql



 #############################   configure v-host for User #######################
 sudo adduser --disabled-password --gecos "" $SITE_USER
 cd $SITE_WORKING_DIR && sudo mkdir $DOMAIN && sudo  chmod -R 775 $DOMAIN && sudo chown -R $SITE_USER:www-data && cd $DOMAIN
 WORKING_PATH=$pwd
 "<VirtualHost *:80>
              ServerName $DOMAIN
              DocumentRoot $WORKING_PATH
             <Directory $WORKING_PATH>
                Options Indexes FollowSymLinks
                AllowOverride All
                Require all granted
            </Directory>

            CustomLog /var/log/apache2/$DOMAIN-access.log combined
            ErrorLog /var/log/apache2/$DOMAIN-error.log

            LogLevel warn

    </VirtualHost>

    "| sudo tee -a  /etc/apache2/sites-available/$DOMAIN.conf
    sudo a2ensite /etc/apache2/sites-available/$DOMAIN.conf
    sudo service apache2 restart 

############################## configure database for site ########################
sudo mysql  -u root  -e  "CREATE DATABASE $DBNAME; "
sudo mysql  -u root  -e   "CREATE USER '$DBUSER'@'%' IDENTIFIED BY '$DBPASSWORD'; "
sudo mysql  -u root  -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'%'"
sudo mysql  -u root  -e "flush privileges; "
sudo mysql  -u root  -e "exit "


####################################  restarting Apache ###########################
sudo service apache2 restart



fi
