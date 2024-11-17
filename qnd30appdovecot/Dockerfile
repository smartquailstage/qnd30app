FROM debian:10

# Añadir las claves GPG y el repositorio de Dovecot
ADD dovecot.gpg /etc/apt/trusted.gpg.d
ADD dovecot.list /etc/apt/sources.list.d

# Establecer variables de entorno
ENV TINI_VERSION v0.18.0
ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

# Actualizar e instalar solo los paquetes necesarios de Dovecot
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
  ca-certificates && \  # Eliminamos ssl-cert aquí
  groupadd -g 1000 vmail && \
  useradd -u 1000 -g 1000 vmail -d /srv/vmail && \
  passwd -l vmail && \
  rm -rf /etc/dovecot && \
  mkdir /srv/mail && \
  chown vmail:vmail /srv/mail && \
  mkdir /etc/dovecot

# Descargar e instalar tini
RUN curl -Lo /sbin/tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
    chmod +x /sbin/tini

# Añadir tus propios certificados al contenedor
ADD cert.pem /etc/ssl/certs/
ADD key.pem /etc/ssl/private/

# Crear enlaces simbólicos para que Dovecot use tus certificados personalizados
RUN ln -s /etc/ssl/certs/cert.pem /etc/dovecot/cert.pem && \
    ln -s /etc/ssl/private/key.pem /etc/dovecot/key.pem

# Añadir archivo de configuración de Dovecot
ADD dovecot.conf /etc/dovecot/dovecot.conf

# Configurar volúmenes para persistencia
VOLUME ["/etc/dovecot", "/srv/mail"]

# Configurar el punto de entrada y el comando para iniciar Dovecot
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/sbin/dovecot", "-F"]
