pour lancer faire les commandes suivantes 

- docker build -t lenomquevousvoulez .
- docker run -d -p 80:80 -p 443:443 -v wordpress_data:/var/www/html/wordpress -v mysql_data:/var/lib/mysql lenomquevousvoulez

voila 
