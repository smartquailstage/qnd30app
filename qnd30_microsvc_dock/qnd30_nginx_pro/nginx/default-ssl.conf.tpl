server {
    listen         443 ssl;
    server_name    ${DOMAIN}   144.126.221.213 127.0.0.1;

    ssl_certificate     /etc/letsencrypt/live/${DOMAIN}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${DOMAIN}/privkey.pem;

    include     /etc/nginx/options-ssl-nginx.conf;

    ssl_dhparam /vol/proxy/ssl-dhparams.pem;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    location /static {
         alias /qnd30_app_stg/qnd30_app_stg/qnd30_app_stg/staticfiles;
         client_max_body_size    1000M;
    }
    
    location /media {
    alias /qnd30_app_stg/qnd30_app_stg/qnd30_app_stg/media;
    client_max_body_size    1000M;
    }


    location / {
        uwsgi_pass           ${APP_HOST}:${APP_PORT};
        include              /etc/nginx/uwsgi_params;
        client_max_body_size 1000M;
    }
}

server {
    listen      443 ssl;
    server_name  www.${DOMAIN} ;

    ssl_certificate     /etc/letsencrypt/live/www.${DOMAIN}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/www.${DOMAIN}/privkey.pem;

    include     /etc/nginx/options-ssl-nginx.conf;

    ssl_dhparam /vol/proxy/ssl-dhparams.pem;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    location /static {
         alias /qnd30_app_stg/qnd30_app_stg/qnd30_app_stg/staticfiles;
         client_max_body_size    1000M;
    }
    
    location /media {
    alias /qnd30_app_stg/qnd30_app_stg/qnd30_app_stg/media;
    client_max_body_size    1000M;
    }


    location / {
        uwsgi_pass           ${APP_HOST}:${APP_PORT};
        include              /etc/nginx/uwsgi_params;
        client_max_body_size 1000M;
    }
}


server {
    listen         443 ssl;
    server_name    mailpost.${DOMAIN}.com;

    ssl_certificate     /etc/letsencrypt/live/${DOMAIN}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${DOMAIN}/privkey.pem;

    include     /etc/nginx/options-ssl-nginx.conf;

    ssl_dhparam /vol/proxy/ssl-dhparams.pem;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    location /static {
         alias /qnd30_app_stg/qnd30_app_stg/qnd30_app_stg/staticfiles;
         client_max_body_size    1000M;
    }
    
    location /media {
        alias /qnd30_app_stg/qnd30_app_stg/qnd30_app_stg/media;
        client_max_body_size    1000M;
    }


    location / {
        uwsgi_pass           ${APP_HOST}:${APP_PORT};
        include              /etc/nginx/uwsgi_params;
        client_max_body_size 1000M;
    }
}


