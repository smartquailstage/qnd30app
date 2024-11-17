FROM debian:10

# Añadir las claves GPG y el repositorio de Dovecot
ADD dovecot.gpg /etc/apt/trusted.gpg.d
ADD dovecot.list /etc/apt/sources.list.d

# Establecer variables de entorno
ENV TINI_VERSION v0.18.0
ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

# Instalar Dovecot y dependencias
RUN apt-get -y update && apt-get -y install \
  dovecot-core \
  dovecot-coi \
  dovecot-gssapi \
  dovecot-imapd \
  dovecot-ldap \
  dovecot-lmtpd \
  dovecot-lua \
  dovecot-managesieved \
  dovecot-mysql \
  dovecot-pgsql \
  dovecot-pop3d \
  dovecot-sieve \
  dovecot-solr \
  dovecot-sqlite \
  dovecot-submissiond \
  ca-certificates \
  ssl-cert && \
  groupadd -g 1000 vmail && \
  useradd -u 1000 -g 1000 vmail -d /srv/vmail && \
  passwd -l vmail && \
  rm -rf /etc/dovecot && \
  chmod +x /sbin/tini && \
  mkdir /srv/mail && \
  chown vmail:vmail /srv/mail && \
  make-ssl-cert generate-default-snakeoil && \
  mkdir /etc/dovecot

# Copiar certificados SSL (asegúrate de que las rutas de origen existan)
COPY juansilvaphoto.com/certs/fullchain.pem /etc/ssl/certs/
COPY juansilvaphoto.com/private/privkey.pem /etc/ssl/private/

# Crear enlaces simbólicos para que Dovecot use tus certificados personalizados
RUN ln -s /etc/ssl/certs/fullchain.pem /etc/dovecot/cert.pem && \
    ln -s /etc/ssl/private/privkey.pem /etc/dovecot/key.pem

# Añadir archivo de configuración de Dovecot
COPY dovecot.conf /etc/dovecot/dovecot.conf

# Configurar volúmenes para persistencia
VOLUME ["/etc/dovecot", "/var/mail/"]

# Configurar el punto de entrada y el comando para iniciar Dovecot
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/sbin/dovecot", "-F"]
