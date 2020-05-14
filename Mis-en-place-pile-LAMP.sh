#!/bin/bash
current_user=`whoami`
echo -e "************Bonjour $current_user !****************\n Dans ce script en va mis en place l'infrastructure LAMP et lancer notre application php !\n Noter bien les instructions sous ce script($0) sera lancer en root ou sous sudo! "
read -p "Pour continuer taper (oui) et n'importe quoi pour quitter :" rep
if [ $rep != oui ];then
	echo "au revoir $current_user !"
	exit
fi
echo "******Màj des paquets******"
sudo apt update

echo "******Installation/Màj d'apache******"
sudo apt install apache2
 
echo "******Installation de module php******"
sudo apt install libapache2-mod-php
echo "******Activation du module php******"
sudo a2enmod php*.*
systemctl restart apache2

echo "******Installation de l'SGBD MySQL******"
sudo apt install mysql-server

echo "******Création de la base de données******"
echo "create database my_db; " | sudo mysql
echo "******la liste des bases de données******"
echo "show databases;" | sudo mysql
echo "Création d'un compte pour pouvoir connecter sur la BD :"

#read -p "Donner votre login:" log
#read -p "Entrer votre mot de passe:" mdp

echo "create user asma identified by 'asma';" | sudo mysql
echo "select user,plugin,host from mysql.user where user='asma'; grant all on my_db.* to asma@'%';"| sudo mysql
echo "Votre compte est bien créé avec tous les droits sur la nouvelle BD ! avec un login: asma et un mot de passe: asma "
echo "use my_db; CREATE TABLE employees (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,name VARCHAR(100) NOT NULL,address VARCHAR(255) NOT NULL, salary INT(10) NOT NULL);" | mysql -u asma -p
echo "******le(s) tableau(x) est/sont bien ajouté(s)******"
echo "desc employees"| mysql -u asma -p

echo "******Installation php-mysql******"
sudo apt install php-mysql
echo "******Installation git******"
sudo apt install git
cd /var/www/html/

sudo git clone https://github.com/asmask/my_app.git
systemctl restart apache2

read -p "Pour ouvrir l'application sur votre navigateur taper (oui) :" repp
if [ $repp = oui ];then
	firefox 127.0.0.1/my_app/index.php
	exit
fi


