# Dockerfile for Postfix
FROM alpine:3.16

LABEL maintainer="your-email@example.com"

ENV container=docker \
    LC_ALL=C \
    TZ=America/Guayaquil

# Environment variables
ENV DOMAIN=juansilvaphoto.com \
    HOSTNAME=mailpost.juansilvaphoto.com \
    DKIM_SELECTOR=default

# Install Postfix and necessary dependencies
RUN apk update && apk add --no-cache \
    postfix \
    postfix-pcre \
    postfix-pgsql \
    cyrus-sasl \
    bash \
    curl \
    openssl \
    iproute2 \
    postfix-ldap \
    postgresql-client \
    pcre \
    db \
    gdbm \
    opendkim

# Create postfix and vmail users and groups if they do not exist
RUN addgroup -g 1001 postfix || true \
    && adduser -D -u 1001 -G postfix -s /sbin/nologin postfix || true \
    && addgroup -g 1002 vmail || true \
    && adduser -D -u 1002 -G vmail -s /sbin/nologin vmail || true

# Create necessary directories and set permissions
RUN mkdir -p /var/spool/postfix/private /var/mail/{cur,new,tmp} \
    && mkdir -p /etc/opendkim/keys \
    && chown -R postfix:postfix /var/spool/postfix \
    && chmod 750 /var/spool/postfix/private \
    && chmod 750 /var/spool/postfix \
    && chown -R vmail:vmail /var/mail \
    && chmod 700 /var/mail \
    && mkdir -p /etc/ssl/certs /etc/ssl/private \
    && chmod 700 /etc/ssl/private \
    && chown root:root /etc/ssl/certs /etc/ssl/private

# Copy configuration files
COPY postfix/main.cf /etc/postfix/main.cf
COPY postfix/master.cf /etc/postfix/master.cf
COPY postfix /etc/postfix
COPY juansilvaphoto.com/certs/fullchain.pem /etc/ssl/certs/
COPY juansilvaphoto.com/private/privkey.pem /etc/ssl/private/

# Set correct permissions for the SSL certificates
RUN chown root:root /etc/ssl/certs/fullchain.pem /etc/ssl/private/privkey.pem \
    && chmod 644 /etc/ssl/certs/fullchain.pem \
    && chmod 600 /etc/ssl/private/privkey.pem

# Configure OpenDKIM
RUN echo "Syslog yes" >> /etc/opendkim.conf \
    && echo "Umask 002" >> /etc/opendkim.conf \
    && echo "Domain $DOMAIN" >> /etc/opendkim.conf \
    && echo "KeyFile /etc/opendkim/keys/$DKIM_SELECTOR.private" >> /etc/opendkim.conf \
    && echo "Selector $DKIM_SELECTOR" >> /etc/opendkim.conf \
    && echo "AutoRestart yes" >> /etc/opendkim.conf \
    && echo "AutoRestartRate 10/1h" >> /etc/opendkim.conf \
    && echo "Background yes" >> /etc/opendkim.conf \
    && echo "TrustedHosts 127.0.0.1" >> /etc/opendkim.conf \
    && echo "SigningTable hash:/etc/opendkim/SigningTable" >> /etc/opendkim.conf \
    && echo "KeyTable hash:/etc/opendkim/KeyTable" >> /etc/opendkim.conf

# Add KeyTable and SigningTable configuration
RUN echo "$DKIM_SELECTOR._domainkey.$DOMAIN $DOMAIN:$DKIM_SELECTOR:/etc/opendkim/keys/$DKIM_SELECTOR.private" > /etc/opendkim/KeyTable \
    && echo "*@$DOMAIN $DKIM_SELECTOR._domainkey.$DOMAIN" > /etc/opendkim/SigningTable

# Create the opendkim user and set permissions on the keys directory
RUN addgroup -g 1003 opendkim || true \
    && adduser -D -u 1003 -G opendkim -s /sbin/nologin opendkim || true \
    && chown -R opendkim:opendkim /etc/opendkim/keys

# Expose the necessary ports for SMTP and secure connections
EXPOSE 25 465 587

# Define the volume
VOLUME ["/var/mail/"]

# Define entrypoint script
COPY postfix/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Set entrypoint for Postfix and OpenDKIM
ENTRYPOINT ["/usr/local/bin/start.sh"]
