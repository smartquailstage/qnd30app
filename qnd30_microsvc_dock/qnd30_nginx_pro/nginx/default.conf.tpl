server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN}  144.126.221.213 ;

    location /.well-known/acme-challenge/ {
        root /vol/www/;
    }

    location /static {
    alias /qnd30_app_stg/qnd30_app_stg/static;
    client_max_body_size    1000M;
     }

    location /media {
    alias  /qnd30_app_stg/qnd30_app_stg/media;
    client_max_body_size    1000M;
     }

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 80;
    server_name  www.${DOMAIN}  144.126.221.213 ;

    location /.well-known/acme-challenge/ {
        root /vol/www/;
    }

    location /static {
    alias /qnd30_app_stg/qnd30_app_stg/static;
    client_max_body_size    1000M;
     }

    location /media {
    alias  /qnd30_app_stg/qnd30_app_stg/media;
    client_max_body_size    1000M;
     }

    location / {
        return 301 https://$host$request_uri;
    }
}

