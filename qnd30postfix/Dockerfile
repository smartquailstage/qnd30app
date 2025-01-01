# Dockerfile for Postfix
FROM alpine:3.16

LABEL maintainer="your-email@example.com"

ENV container=docker \
    LC_ALL=C \
    TZ=America/Guayaquil

# Environment variables
ENV DOMAIN=juansilvaphoto.com
ENV HOSTNAME=mailpost.juansilvaphoto.com

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
    gdbm

# Create postfix and vmail users and groups if they do not exist
RUN addgroup -g 1001 postfix || true \
    && adduser -D -u 1001 -G postfix -s /sbin/nologin postfix || true \
    && addgroup -g 1002 vmail || true \
    && adduser -D -u 1002 -G vmail -s /sbin/nologin vmail || true

# Create necessary directories and set permissions
RUN mkdir -p /var/spool/postfix/private /var/spool/postfix \
    /var/mail/juansilvaphoto.com/info/Maildir/{cur,new,tmp} \
    # Set ownership and permissions for /var/spool/postfix
    && chown -R postfix:postfix /var/spool/postfix \
    && chmod 750 /var/spool/postfix/private \
    && chmod 750 /var/spool/postfix \
    # Set ownership and permissions for /var/mail and Maildir structure
    && chown -R vmail:vmail /var/mail \
    && chmod -R 700 /var/mail \
    # Set permissions for Maildir subdirectories
    && chown -R vmail:vmail /var/mail/juansilvaphoto.com/info/Maildir \
    && chmod -R 700 /var/mail/juansilvaphoto.com/info/Maildir

# Copy configuration files
COPY postfix/transport.pcre /etc/postfix/transport.pcre
COPY postfix/virtual /etc/postfix/virtual
COPY postfix/main.cf /etc/postfix/main.cf
COPY postfix/master.cf /etc/postfix/master.cf
COPY postfix/sasl_passwd /etc/postfix/
COPY postfix /etc/postfix
COPY mailpost.juansilvaphoto.com/certs/fullchain.pem /etc/letsencrypt/live/mailpost.juansilvaphoto.com/fullchain.pem 
COPY mailpost.juansilvaphoto.com/private/privkey.pem /etc/letsencrypt/live/mailpost.juansilvaphoto.com/privkey.pem

# Set correct permissions for the SSL certificates
RUN chown root:root \
        /etc/letsencrypt/live/mailpost.juansilvaphoto.com/fullchain.pem \
        /etc/letsencrypt/live/mailpost.juansilvaphoto.com/privkey.pem \
    && chmod 644 /etc/letsencrypt/live/mailpost.juansilvaphoto.com/fullchain.pem \
    && chmod 600 /etc/letsencrypt/live/mailpost.juansilvaphoto.com/privkey.pem

# Expose the necessary ports for SMTP and secure connections
EXPOSE 25 465 587

# Define volumes for persistent data
VOLUME ["/var/mail", "/etc/letsencrypt"]

# Define entrypoint script
COPY postfix/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

ENTRYPOINT ["/usr/local/bin/start.sh"]
