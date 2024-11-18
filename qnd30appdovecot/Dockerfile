FROM debian:10

# Añadir las claves GPG y el repositorio de Dovecot
ADD dovecot.gpg /etc/apt/trusted.gpg.d
ADD dovecot.list /etc/apt/sources.list.d

# Establecer variables de entorno
ENV TINI_VERSION v0.18.0
ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

# Actualizar e instalar los paquetes necesarios de Dovecot y curl
RUN apt-get -y update && apt-get -y install \
  curl \
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
  ca-certificates && \
  groupadd -g 1000 vmail && \
  useradd -u 1000 -g 1000 vmail -d /srv/vmail && \
  passwd -l vmail && \
  rm -rf /etc/dovecot && \
  mkdir -p /srv/mail && \
  chown vmail:vmail /srv/mail && \
  mkdir -p /etc/dovecot

# Descargar e instalar tini
RUN curl -Lo /sbin/tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
    chmod +x /sbin/tini

# Copiar los certificados SSL (asegúrate de que las rutas de origen existan)
COPY juansilvaphoto.com/certs/cert.pem /etc/ssl/certs/cert.pem
COPY juansilvaphoto.com/private/privkey.pem /etc/ssl/private/privkey.pem

# Crear enlaces simbólicos para los certificados de Dovecot
RUN ln -s /etc/ssl/certs/cert.pem /etc/dovecot/cert.pem && \
    ln -s /etc/ssl/private/privkey.pem /etc/dovecot/key.pem

# Copiar archivo de configuración SSL
COPY ConfigFiles/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf

# Añadir archivo de configuración de Dovecot
COPY dovecot.conf /etc/dovecot/dovecot.conf

# Configurar volúmenes para persistencia
VOLUME ["/etc/dovecot", "/srv/mail"]

# Configurar el punto de entrada y el comando para iniciar Dovecot
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/sbin/dovecot", "-F"]
