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

# Create the directories if they don't exist
mkdir -p "$MAIL_DIR"

# Adjust ownership and permissions for the main mail directory
echo "Setting permissions and ownership for $MAIL_DIR"
chown -R $USER:$GROUP "$MAIL_DIR"
chmod 750 "$MAIL_DIR"  # Permissions to allow group access and prevent others

# Recursively adjust ownership and permissions for all directories under /var/mail
echo "Setting permissions and ownership for all directories under $MAIL_DIR"
find "$MAIL_DIR" -type d -exec chown $USER:$GROUP {} \; -exec chmod 750 {} \;  # Directories need execute permissions
find "$MAIL_DIR" -type f -exec chown $USER:$GROUP {} \; -exec chmod 640 {} \;  # Files need read and write for owner

# Check if /var/mail/info@mail.smartquail.io/tmp exists; create if needed
INFO_DIR="$MAIL_DIR/info@mailpost.juansilvaphoto.com/tmp"
mkdir -p "$INFO_DIR"

# Adjust ownership and permissions for the specific info directory
echo "Setting permissions and ownership for $INFO_DIR"
chown $USER:$GROUP "$INFO_DIR"
chmod 750 "$INFO_DIR"  # Directories under user email need write access for the user and group

# Verify the results
echo "Verification of permissions and ownership:"
ls -ld "$MAIL_DIR"
ls -ld "$MAIL_DIR/info@mailpost.juansilvaphoto.com"
ls -ld "$INFO_DIR"

echo "Permissions and ownership have been set."

# Keep the container running by tailing the log file
# If the log file does not exist, this will fail. So, let's use a different method to keep the container running.
tail -f /var/log/dovecot.log

# Ensure that Dovecot is running in the foreground (this might be preferred for Docker containers)
exec dovecot -F
