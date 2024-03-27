FROM nginx:1.23.0-alpine

COPY ./nginx/* /etc/nginx/
COPY ./nginx/run.sh /run.sh
COPY ./ssl-certs-juansilvaphoto/https/juansilvaphoto.com/* /etc/letsencrypt/live/juansilvaphoto.com/
COPY ./ssl-certs-juansilvaphoto/https/www.juansilvaphoto.com/* /etc/letsencrypt/live/www.juansilvaphoto.com/
COPY ./ssl-certs-juansilvaphoto/mail/mailpost.juansilvaphoto.com/* /etc/letsencrypt/live/mailpost.juansilvaphoto.com/

ENV DOMAIN=juansilvaphoto.com
ENV LISTEN_PORT=80
ENV NGINX_PROXY=http://qnd30_app_stg:9000
ENV APP_HOST=qnd30_app_stg
ENV APP_PORT=9000

USER root

RUN apk add --no-cache openssl bash
RUN chmod +x /run.sh

RUN mkdir -p /qnd30_app_stg/qnd30_app_stg/qnd30_app_stg/staticfiles && \
    chmod 755 /qnd30_app_stg/qnd30_app_stg/qnd30_app_stg/staticfiles && \
    mkdir -p /qnd30_app_stg/qnd30_app_stg/qnd30_app_stg/media && \
    chmod 755 /qnd30_app_stg/qnd30_app_stg/qnd30_app_stg/media && \
    mkdir -p /qnd30_app_stg/qnd30_app_stg/qnd30_app_stg/static && \
    chmod 755 /qnd30_app_stg/qnd30_app_stg/qnd30_app_stg/static 

VOLUME /qnd30_app_stg/qnd30_app_stg/qnd30_app_stg/staticfiles
VOLUME /qnd30_app_stg/qnd30_app_stg/qnd30_app_stg/mediafiles
VOLUME /qnd30_app_stg/qnd30_app_stg/qnd30_app_stg/static
VOLUME /vol/www
VOLUME /vol/proxy
VOLUME /etc/letsencrypt

CMD ["/run.sh" , "/run_2.sh"]