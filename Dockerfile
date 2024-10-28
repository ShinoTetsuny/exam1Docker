FROM debian:buster

RUN apt-get update && \
    apt-get install -y apache2 php libapache2-mod-php php-mysql default-mysql-server wget unzip curl openssl && \
    apt-get clean

COPY wordpress.sql /

RUN service mysql start && \
    mysql -e "CREATE DATABASE wordpress;" && \
    mysql -e "CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';" && \
    mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'user'@'localhost';" && \
    mysql -e "FLUSH PRIVILEGES;"

RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    mv wordpress /var/www/html/ && \
    chown -R www-data:www-data /var/www/html/wordpress

RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip && \
    unzip phpMyAdmin-latest-all-languages.zip && \
    mv phpMyAdmin-*-all-languages /var/www/html/phpmyadmin && \
    chown -R www-data:www-data /var/www/html/phpmyadmin

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY default-ssl.conf /etc/apache2/sites-available/default-ssl.conf

RUN mkdir /etc/apache2/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/apache2/ssl/apache.key \
    -out /etc/apache2/ssl/apache.crt \
    -subj "/C=FR/ST=France/L=Paris/O=MonEntreprise/OU=IT/CN=localhost"

RUN a2enmod ssl && \
    a2ensite default-ssl 000-default

EXPOSE 80 443

CMD service mysql start && \
    mysql -u user -ppassword wordpress < /wordpress.sql && \
    apachectl -D FOREGROUND
