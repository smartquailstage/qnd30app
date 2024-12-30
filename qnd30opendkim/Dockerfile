FROM debian:bullseye

# Actualizar e instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y \
    opendkim \
    opendkim-tools \
    openssl && \
    procps && \
    apt-get clean

# Crear el grupo y el usuario 'opendkim' de forma segura (evitar errores si ya existen)
RUN groupadd -r opendkim || true && \
    useradd -r -g opendkim -m opendkim || true && \
    # Crear el grupo y el usuario postfix
    groupadd -r postfix || true && \
    useradd -r -g postfix -m postfix || true && \
    mkdir -p /etc/opendkim/keys /var/spool/postfix/opendkim /var/run/opendkim && \
    chown -R opendkim:opendkim /etc/opendkim /var/spool/postfix /var/run/opendkim && \
    chmod 700 /etc/opendkim/keys && \
    chmod 700 /var/spool/postfix/opendkim && \
    chmod 755 /etc/opendkim && \
    chmod 755 /var/spool/postfix && \
    chmod 755 /var/run/opendkim

# Copiar la configuración de OpenDKIM
COPY opendkim.conf /etc/opendkim.conf
COPY KeyTable /etc/opendkim/KeyTable
COPY SigningTable /etc/opendkim/SigningTable
COPY TrustedHosts /etc/opendkim/TrustedHosts

# Script para generar las claves DKIM
COPY generate_keys.sh /usr/local/bin/generate_keys.sh
RUN chmod +x /usr/local/bin/generate_keys.sh

# Asegurar que postfix pueda acceder a los archivos de OpenDKIM
RUN chown -R opendkim:postfix /var/spool/postfix/opendkim && \
    chmod 750 /var/spool/postfix/opendkim

# Exponer el puerto y volúmenes
EXPOSE 8891

VOLUME ["/var/spool/postfix/opendkim"]
VOLUME ["/etc/opendkim/keys"]

# Cambiar el propietario de las carpetas para evitar problemas de permisos al ejecutar OpenDKIM
RUN chown -R opendkim:opendkim /etc/opendkim /var/spool/postfix /var/run/opendkim

# Ejecutar el script de generación de claves y luego OpenDKIM como usuario opendkim
USER root
CMD ["/bin/bash", "-c", "/usr/local/bin/generate_keys.sh"]
