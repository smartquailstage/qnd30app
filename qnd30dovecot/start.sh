#!/bin/sh

# Define the user and group
USER="vmail"
GROUP="vmail"

# Define the main directory
MAIL_DIR="/var/mail"

# Start Dovecot in the background
echo "Starting Dovecot..."
dovecot &

# Wait a few seconds to ensure Dovecot starts up correctly
sleep 10

# Create the main mail directory if it doesn't exist
echo "Ensuring the main mail directory exists: $MAIL_DIR"
mkdir -p "$MAIL_DIR"

# Adjust ownership and permissions for the main mail directory
echo "Setting permissions and ownership for $MAIL_DIR"
chown -R $USER:$GROUP "$MAIL_DIR"
chmod 755 "$MAIL_DIR"

# Recursively adjust ownership and permissions for all directories and files under $MAIL_DIR
echo "Setting permissions and ownership for all directories and files under $MAIL_DIR"
find "$MAIL_DIR" -type d -exec chown $USER:$GROUP {} \; -exec chmod 755 {} \;
find "$MAIL_DIR" -type f -exec chown $USER:$GROUP {} \; -exec chmod 644 {} \;

# Check if /var/spool/postfix/private/auth exists; create it if needed
if [ ! -e /var/spool/postfix/private/auth ]; then
    echo "Creating /var/spool/postfix/private/auth socket"
    mkdir -p /var/spool/postfix/private
    touch /var/spool/postfix/private/auth
    chown dovecot:dovecot /var/spool/postfix/private/auth
    chmod 0666 /var/spool/postfix/private/auth
fi

# Check if /var/spool/postfix/private/dovecot-lmtp exists; create it if needed
if [ ! -e /var/spool/postfix/private/dovecot-lmtp ]; then
    echo "Creating /var/spool/postfix/private/dovecot-lmtp socket"
    touch /var/spool/postfix/private/dovecot-lmtp
    chown dovecot:dovecot /var/spool/postfix/private/dovecot-lmtp
    chmod 0660 /var/spool/postfix/private/dovecot-lmtp
fi

# Check if /var/mail/info@juansilvaphoto.com/tmp exists; create if needed
INFO_DIR="$MAIL_DIR/info@juansilvaphoto.com/tmp"
if [ ! -d "$INFO_DIR" ]; then
    echo "Creating $INFO_DIR"
    mkdir -p "$INFO_DIR"
    chown -R $USER:$GROUP "$INFO_DIR"
    chmod 755 "$INFO_DIR"
fi

# Verify the results
echo "Verification of permissions and ownership:"
ls -ld "$MAIL_DIR"
ls -ld "$INFO_DIR"
ls -ld /var/spool/postfix/private/auth
ls -ld /var/spool/postfix/private/dovecot-lmtp

echo "Permissions and ownership have been set."

# Ensure that Dovecot is running in the foreground (this is required for Docker containers)
exec dovecot -F
