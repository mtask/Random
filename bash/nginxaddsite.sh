
nginxsite()
{
    tee > $domain  << EOF 
server {
    listen 443;
    ssl                 on;
    ssl_certificate     /etc/nginx/ssl/x.wildcert.com.crt;
    ssl_certificate_key /etc/nginx/ssl/x.wildcert.com.key;

    server_name $domain;

    location / {
        proxy_pass https://backend/;
        proxy_set_header Host $domain;
    }
}
EOF
}

domain=$1

if [ $# != 1 ];
then
   echo "aaaaargggssss????"
   exit 1
fi

nginxsite
ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled
nginx -t && nginx -s reload