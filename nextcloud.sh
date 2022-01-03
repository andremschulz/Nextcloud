#!/bin/bash
HORAINICIAL=$(date +%T)
LOG="/var/log/$(echo $0 | cut -d'/' -f2)"
USER="root"
PASSWORD=`(date +%s | sha256sum | base64 | head -c 32;)`
CREDENCIAL= echo " usuário: ${USER} senha: ${PASSWORD}" > /root/credenciais.txt 
DATABASE="CREATE DATABASE nextcloud;"
USERDATABASE="CREATE USER 'nextcloud' IDENTIFIED BY 'nextcloud';"
GRANTDATABASE="GRANT USAGE ON *.* TO 'nextcloud' IDENTIFIED BY 'nextcloud';"
GRANTALL="GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud' IDENTIFIED BY '$PASSWORD' WITH GRANT OPTION;"
FLUSH="FLUSH PRIVILEGES;"
RELEASE="https://download.nextcloud.com/server/releases/nextcloud-21.0.2.zip"
export DEBIAN_FRONTEND="noninteractive"
clear
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" 
	add-apt-repository universe 
	add-apt-repository multiverse 
    add-apt-repository ppa:ondrej/php -y 
sleep 1
    sudo rm /var/cache/debconf/config.dat
    sudo rm -f /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/cache/apt/archives/lock 
    sudo dpkg --configure -a 
    sleep 2;
    sudo apt --fix-broken install -y  
    apt update 
sleep 2;
	apt -y install software-properties-common lamp-server^ php8.0 perl python apt-transport-https unzip 
	apt -y install php-cli php-common php-mbstring php-gd php-intl php-xml php-mysql php-zip php-curl php-xmlrpc 
    apt -y install php8.0 
    apt -y install php8.0-common php8.0-mysql php8.0-xml php8.0-xmlrpc php8.0-curl php8.0-gd php8.0-imagick php8.0-cli php8.0-dev php8.0-imap php8.0-mbstring php8.0-opcache php8.0-soap php8.0-zip php8.0-intl
	systemctl restart apache2 
sleep 1;
echo | a2dismod autoindex 
	a2enmod rewrite 
	a2enmod headers 
	a2enmod env 
	a2enmod dir 
	a2enmod mime 
    a2dismod php7.2 
    a2enmod php8.0 
echo -e "Fazendo o download e Instalando o nextcloud do site Oficial, aguarde..."
	rm -v nextcloud-21.0.2.zip 
	wget $RELEASE -O nextcloud-21.0.2.zip 
	unzip nextcloud-21.0.2.zip 
	mv -v nextcloud/ /var/www/html/nextcloud/ 
	chown -Rv www-data:www-data /var/www/html/nextcloud/ 
	chmod -Rv 755 /var/www/html/nextcloud/ 
    sed -i 's/expose_php = On/expose_php = Off /g' /etc/php/8.0/apache2/php.ini  
    sed -i 's/bind-address/#bind-address /g' /etc/mysql/mysql.conf.d/mysqld.cnf 
    sed -i '225 i ServerTokens ProductOnly' /etc/apache2/apache2.conf 
    sed -i '226 i ServerSignature Off' /etc/apache2/apache2.conf 
sleep 1
	mysql -u $USER -p$PASSWORD -e "$DATABASE" mysql 
	mysql -u $USER -p$PASSWORD -e "$USERDATABASE" mysql 
	mysql -u $USER -p$PASSWORD -e "$GRANTDATABASE" mysql 
	mysql -u $USER -p$PASSWORD -e "$GRANTALL" mysql 
	mysql -u $USER -p$PASSWORD -e "$FLUSH" mysql 
sleep 1
apt update
systemctl restart apache2
echo -e "Instalação do nextcloud feita com Sucesso!!!."
	HORAFINAL=`date +%T`
	HORAINICIAL01=$(date -u -d "$HORAINICIAL" +"%s")
	HORAFINAL01=$(date -u -d "$HORAFINAL" +"%s")
	TEMPO=`date -u -d "0 $HORAFINAL01 sec - $HORAINICIAL01 sec" +"%H:%M:%S"`
	echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Fim do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" 
exit 1
