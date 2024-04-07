upstream django {
    # server unix:///path/to/your/mysite/mysite.sock; # for a file socket
    server qnd30_app_stg:9000; # for a web port socket (we'll use this first)
}

server {
    listen         443 ssl;
    server_name    ${DOMAIN}   64.23.235.13 127.0.0.1;

    ssl_certificate     /etc/letsencrypt/live/${DOMAIN}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${DOMAIN}/privkey.pem;

    include     /etc/nginx/options-ssl-nginx.conf;

    ssl_dhparam /vol/proxy/ssl-dhparams.pem;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    location /static {
         alias /qnd30app/qnd30_app_stg/qnd30_app_stg/static;
         client_max_body_size    1000M;
    }
    
    location /media {
    alias /qnd30app/qnd30_app_stg/qnd30_app_stg/media;
    client_max_body_size    1000M;
    }


    location / {
        uwsgi_pass           ${APP_HOST}:${APP_PORT};
        include              /etc/nginx/uwsgi_params;
        add_header 'Access-Control-Allow-Origin' 'https://www.juansilvaphoto.com';
        add_header Access-Control-Allow-Methods "GET, POST, OPTIONS";
        add_header Access-Control-Allow-Headers "Authorization, Content-Type, Accept";
        add_header Access-Control-Allow-Credentials "true";
        proxy_set_header X-Forwarded-Proto https;
        client_max_body_size 2000M;
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
         alias /qnd30app/qnd30_app_stg/qnd30_app_stg/static;
         client_max_body_size    2000M;
    }
    
    location /media {
    alias /qnd30app/qnd30_app_stg/qnd30_app_stg/media;
    add_header 'Access-Control-Allow-Origin' 'https://www.juansilvaphoto.com';
    add_header Access-Control-Allow-Methods "GET, POST, OPTIONS";
    add_header Access-Control-Allow-Headers "Authorization, Content-Type, Accept";
    add_header Access-Control-Allow-Credentials "true";
    proxy_set_header X-Forwarded-Proto https;
    client_max_body_size    2000M;
    }


    location / {
        uwsgi_pass           ${APP_HOST}:${APP_PORT};
        include              /etc/nginx/uwsgi_params;
        add_header 'Access-Control-Allow-Origin' 'https://www.juansilvaphoto.com';
        add_header Access-Control-Allow-Methods "GET, POST, OPTIONS";
        add_header Access-Control-Allow-Headers "Authorization, Content-Type, Accept";
        add_header Access-Control-Allow-Credentials "true";
        proxy_set_header X-Forwarded-Proto https;
        client_max_body_size    2000M;
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
         alias /qnd30app/qnd30_app_stg/qnd30_app_stg/static;
         client_max_body_size    2000M;
    }
    
    location /media {
        alias /qnd30app/qnd30_app_stg/qnd30_app_stg/media;
        client_max_body_size    2000M;
    }


    location / {
        uwsgi_pass           ${APP_HOST}:${APP_PORT};
        include              /etc/nginx/uwsgi_params;
        client_max_body_size 1000M;
    }
}


