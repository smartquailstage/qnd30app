FROM debian:11-slim

LABEL org.opencontainers.image.authors="dovecot@dovecot.org"

# Configuración de entorno
ENV container=docker \
    LC_ALL=C \
    TZ=America/Guayaquil \
    DEBIAN_FRONTEND=noninteractive

# Añadir claves y fuentes de APT
COPY dovecot.gpg /etc/apt/keyrings/dovecot.gpg
COPY dovecot.list /etc/apt/sources.list.d/

# Copiar archivos de configuración de Dovecot y Postfix
COPY dovecot.conf /etc/dovecot/conf.d/dovecot.conf
COPY postfix/main.cf /etc/postfix/main.cf

# Copiar certificados SSL
COPY juansilvaphoto.com/certs/fullchain.pem /etc/dovecot/certs/fullchain.pem
COPY juansilvaphoto.com/private/privkey.pem /etc/dovecot/private/privkey.pem

# Archivos de configuración postfix+Dovecot
COPY configPD/dovecot-sql.conf.ext /etc/dovecot/dovecot-sql.conf.ext
COPY configPD/10-auth.conf /etc/dovecot/conf.d/10-auth.conf
COPY configPD/10-mail.conf /etc/dovecot/conf.d/10-mail.conf
COPY configPD/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf

# Copiar el script de inicio
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Crear usuario y grupo postfix si no existen
RUN if ! id -u postfix > /dev/null 2>&1; then \
        addgroup --system postfix && \
        adduser --system --ingroup postfix --no-create-home --shell /sbin/nologin postfix; \
    fi

# Instalar paquetes necesarios y configurar el entorno
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      tini \
      dovecot-core \
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
      ssl-cert \
      vim \
      tzdata && \
    rm -rf /var/lib/apt/lists/*

# Crear el grupo y usuario 'vmail' para el correo
RUN groupadd -g 1000 vmail && \
    useradd -u 1000 -g vmail -d /srv/vmail -s /sbin/nologin vmail && \
    passwd -l vmail && \
    mkdir -p /srv/mail && \
    chown vmail:vmail /srv/mail && \
    mkdir -p /home/info && \
    chown vmail:vmail /home/info && \
    mkdir -p /home/info/Maildir && \
    chown -R vmail:vmail /home/info/Maildir && \
    chmod 700 /home/info/Maildir && \
    # Crear los directorios de Maildir y asegurar permisos
    mkdir -p /home/info/Maildir/tmp && \
    chmod 700 /home/info/Maildir/tmp && \
    mkdir -p /home/info/Maildir/.Drafts && \
    chmod 700 /home/info/Maildir/.Drafts && \
    mkdir -p /home/info/Maildir/.Sent && \
    chmod 700 /home/info/Maildir/.Sent && \
    mkdir -p /home/info/Maildir/.Junk && \
    chmod 700 /home/info/Maildir/.Junk && \
    mkdir -p /home/info/Maildir/.Trash && \
    chmod 700 /home/info/Maildir/.Trash

# Exponer los puertos necesarios para IMAP, POP3 y conexiones seguras
EXPOSE 24 110 143 990 993

# Definir volúmenes
VOLUME ["/etc/dovecot", "/home/info/Maildir"]

# Usar el script de inicio para arrancar el servicio
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/start.sh"]
