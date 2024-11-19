server {
    listen 80;
    server_name ${DOMAIN} 64.23.235.13;

    location /.well-known/acme-challenge/ {
        root /vol/www/;
    }

    location /static {
        alias /qnd30app/qnd30_app_stg/qnd30_app_stg/static;
        client_max_body_size 1000M;
        add_header 'Access-Control-Allow-Origin' '*';  # Permitir acceso desde cualquier origen, ajusta según sea necesario
    }

    location /media {
        alias /qnd30app/qnd30_app_stg/qnd30_app_stg/media;
        client_max_body_size 1000M;
        add_header 'Access-Control-Allow-Origin' '*';  # Permitir acceso desde cualquier origen, ajusta según sea necesario
    }

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 80;
    server_name www.${DOMAIN} 144.126.221.213;

    location /.well-known/acme-challenge/ {
        root /vol/www/;
    }

    location /static {
        alias /qnd30app/qnd30_app_stg/qnd30_app_stg/static;
        add_header 'Access-Control-Allow-Origin' 'https://www.juansilvaphoto.com';
        add_header Access-Control-Allow-Methods "GET, POST, OPTIONS";
        add_header Access-Control-Allow-Headers "Authorization, Content-Type, Accept";
        add_header Access-Control-Allow-Credentials "true";
        client_max_body_size 2000M;
    }

    location /media {
        alias /qnd30app/qnd30_app_stg/qnd30_app_stg/media;
        add_header 'Access-Control-Allow-Origin' 'https://www.juansilvaphoto.com';
        add_header Access-Control-Allow-Methods "GET, POST, OPTIONS";
        add_header Access-Control-Allow-Headers "Authorization, Content-Type, Accept";
        add_header Access-Control-Allow-Credentials "true";
        client_max_body_size 2000M;
    }

    location / {
        return 301 https://$host$request_uri;
    }
}
