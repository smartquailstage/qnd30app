#!/bin/sh

# Define the user and group
USER="vmail"
GROUP="vmail"

# Define the main directory
MAIL_DIR="/home/info/Maildir"

# Start Dovecot in the background if it's not already running
if ! pidof dovecot > /dev/null; then
    echo "Starting Dovecot..."
    dovecot &
    # Wait a few seconds to ensure Dovecot starts up correctly
    sleep 10
else
    echo "Dovecot is already running."
fi

# Create the directories if they don't exist
mkdir -p "$MAIL_DIR"

# Adjust ownership and permissions for the main mail directory
echo "Setting permissions and ownership for $MAIL_DIR"
chown -R $USER:$GROUP "$MAIL_DIR"
chmod 700 "$MAIL_DIR"  # Restrict access to the maildir

# Recursively adjust ownership and permissions for all directories and files
echo "Setting permissions and ownership for all directories and files under $MAIL_DIR"
find "$MAIL_DIR" -type d -exec chown $USER:$GROUP {} \; -exec chmod 700 {} \;  # Directories should be 700
find "$MAIL_DIR" -type f -exec chown $USER:$GROUP {} \; -exec chmod 600 {} \;  # Files should be 600

# Check if /home/info/Maildir/tmp exists; create if needed
INFO_DIR="$MAIL_DIR/tmp"
mkdir -p "$INFO_DIR"

# Adjust ownership and permissions for the specific info directory
echo "Setting permissions and ownership for $INFO_DIR"
chown $USER:$GROUP "$INFO_DIR"
chmod 700 "$INFO_DIR"  # Permissions should be restrictive

# Verify the results
echo "Verification of permissions and ownership:"
ls -ld "$MAIL_DIR"
ls -ld "$INFO_DIR"

echo "Permissions and ownership have been set."
