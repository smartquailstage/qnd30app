FROM debian:bullseye

# Actualizar e instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y \
    opendkim \
    opendkim-tools \
    && apt-get clean

# Crear el grupo y el usuario 'opendkim' de forma segura
RUN groupadd -r opendkim && \
    useradd -r -g opendkim -m opendkim && \
    mkdir -p /etc/opendkim/keys && \
    chown -R opendkim:opendkim /etc/opendkim/keys

# Crear directorios para el socket y las claves de OpenDKIM
RUN mkdir -p /var/spool/postfix/opendkim && \
    chown -R opendkim:opendkim /var/spool/postfix/opendkim

# Copiar la configuración de OpenDKIM (asegúrate de que estos archivos existan en el contexto de construcción)
COPY opendkim.conf /etc/opendkim.conf
COPY KeyTable /etc/opendkim/KeyTable
COPY SigningTable /etc/opendkim/SigningTable
COPY TrustedHosts /etc/opendkim/TrustedHosts

# Script para generar las claves DKIM
COPY generate_keys.sh /usr/local/bin/generate_keys.sh
RUN chmod +x /usr/local/bin/generate_keys.sh

# Crear el directorio de claves y dar permisos adecuados
RUN mkdir -p /etc/opendkim/keys && \
    chown -R opendkim:opendkim /etc/opendkim/keys && \
    chmod 700 /etc/opendkim/keys

# Exponer el socket y las claves como volúmenes
VOLUME ["/var/spool/postfix/opendkim"]
VOLUME ["/etc/opendkim/keys"]

# Ejecutar el script de generación de claves y luego OpenDKIM
CMD ["/bin/bash", "-c", "/usr/local/bin/generate_keys.sh && opendkim -f -x /etc/opendkim.conf"]
