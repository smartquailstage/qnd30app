FROM debian:bullseye

# Actualizar e instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y \
    opendkim \
    opendkim-tools \
    openssl \
    procps && \
    apt-get clean

# Crear grupos y usuarios necesarios
RUN groupadd -r opendkim || true && \
    useradd -r -g opendkim -m opendkim || true && \
    groupadd -r postfix || true && \
    useradd -r -g postfix -m postfix || true && \
    mkdir -p /etc/opendkim/keys /var/spool/postfix/opendkim /var/run/opendkim && \
    chown -R opendkim:opendkim /etc/opendkim /var/run/opendkim && \
    chown -R opendkim:postfix /var/spool/postfix/opendkim && \
    chmod 700 /etc/opendkim/keys && \
    chmod 750 /var/spool/postfix/opendkim && \
    chmod 755 /etc/opendkim /var/run/opendkim

# Copiar los archivos de configuración necesarios
COPY opendkim.conf /etc/opendkim.conf
COPY KeyTable /etc/opendkim/KeyTable
COPY SigningTable /etc/opendkim/SigningTable
COPY TrustedHosts /etc/opendkim/TrustedHosts

# Script para generar las claves DKIM
COPY generate_keys.sh /usr/local/bin/generate_keys.sh
RUN chmod +x /usr/local/bin/generate_keys.sh

# Exponer el puerto de OpenDKIM y configurar volúmenes
EXPOSE 8891
VOLUME ["/var/spool/postfix/opendkim", "/etc/opendkim/keys"]

# Configuración final
CMD ["/bin/bash", "-c", "/usr/local/bin/generate_keys.sh && service opendkim start && tail -f /dev/null"]
