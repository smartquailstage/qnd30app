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
  useradd -u 1000 -g 1000 -m vmail && \
  passwd -l vmail && \
  groupadd -g 1010 postfix && \
  useradd -u 1010 -g 1010 -m postfix && \
  passwd -l postfix && \
  groupadd -g 8 mail && \
  usermod -aG mail vmail && \
  # Crear directorios necesarios y asignar permisos
  mkdir -p /srv/mail && \
  chown -R vmail:vmail /srv/mail && \
  chmod 770 /srv/mail && \
  mkdir -p /etc/dovecot && \
  chown -R vmail:vmail /etc/dovecot && \
  chmod 770 /etc/dovecot && \
  mkdir -p /var/spool/postfix && \
  chown -R postfix:postfix /var/spool/postfix && \
  chmod 770 /var/spool/postfix && \
  # No eliminamos el directorio /etc/dovecot, lo configuramos
  # Eliminar archivo master.pid si existe (para evitar conflictos al iniciar Dovecot)
  mkdir -p /run/dovecot && rm -f /run/dovecot/master.pid

# Descargar e instalar tini
RUN curl -Lo /sbin/tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
    chmod +x /sbin/tini

# Copiar los certificados SSL (asegúrate de que las rutas de origen existan)
COPY mailpost.juansilvaphoto.com/certs/cert.pem /etc/letsencrypt/live/mailpost.juansilvaphoto.com/cert.pem
COPY mailpost.juansilvaphoto.com/private/privkey.pem /etc/letsencrypt/live/mailpost.juansilvaphoto.com/privkey.pem

# Crear enlaces simbólicos para los certificados de Dovecot
RUN ln -s /etc/letsencrypt/live/mailpost.juansilvaphoto.com/cert.pem /etc/dovecot/cert.pem && \
    ln -s /etc/letsencrypt/live/mailpost.juansilvaphoto.com/privkey.pem /etc/dovecot/key.pem

# Copiar archivo de configuración SSL
COPY ConfigFiles/10-master.conf /etc/dovecot/conf.d/10-master.conf
COPY ConfigFiles/dovecot-sql.conf.ext /etc/dovecot/dovecot-sql.conf.ext

# Añadir archivo de configuración de Dovecot
COPY dovecot.conf /etc/dovecot/dovecot.conf

# Configurar volúmenes para persistencia
VOLUME ["/etc/dovecot", "/srv/mail"]

# Configurar el punto de entrada y el comando para iniciar Dovecot
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/sbin/dovecot", "-F"]
