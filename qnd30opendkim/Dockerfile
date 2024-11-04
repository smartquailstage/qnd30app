FROM debian:bullseye

# Instalar OpenDKIM y sus herramientas
RUN apt-get update && \
    apt-get install -y opendkim opendkim-tools && \
    apt-get clean

# Crear usuario y grupo opendkim si no existen
RUN groupadd -r opendkim && useradd -r -g opendkim opendkim

# Crear directorios para las claves y el socket
RUN mkdir -p /etc/opendkim/keys && \
    mkdir -p /var/spool/postfix/opendkim && \
    chown -R opendkim:opendkim /etc/opendkim/keys && \
    chown -R opendkim:opendkim /var/spool/postfix/opendkim && \
    chmod 700 /etc/opendkim/keys

# Copiar configuración
COPY opendkim.conf /etc/opendkim.conf
COPY KeyTable /etc/opendkim/KeyTable
COPY SigningTable /etc/opendkim/SigningTable
COPY TrustedHosts /etc/opendkim/TrustedHosts

# Script para generar claves DKIM
COPY generate_keys.sh /usr/local/bin/generate_keys.sh
RUN chmod +x /usr/local/bin/generate_keys.sh

# Exponer el socket y las claves
VOLUME ["/var/spool/postfix/opendkim"]
VOLUME ["/etc/opendkim/keys"]

# Ejecutar script y luego OpenDKIM
CMD ["/bin/bash", "-c", "/usr/local/bin/generate_keys.sh && opendkim -f -x /etc/opendkim.conf"]
