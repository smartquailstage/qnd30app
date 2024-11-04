FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y opendkim opendkim-tools && \
    apt-get clean

# Crear directorio para el socket
RUN mkdir -p /var/spool/postfix/opendkim && \
    chown -R opendkim:opendkim /var/spool/postfix/opendkim

# Copiar configuración
COPY opendkim.conf /etc/opendkim.conf
COPY KeyTable /etc/opendkim/KeyTable
COPY SigningTable /etc/opendkim/SigningTable
COPY TrustedHosts /etc/opendkim/TrustedHosts

# Exponer el socket
VOLUME ["/var/spool/postfix/opendkim"]

CMD ["opendkim", "-f", "-x", "/etc/opendkim.conf"]
