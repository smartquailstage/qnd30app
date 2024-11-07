#!/bin/bash

# Define the user and group
USER="vmail"
GROUP="vmail"

# Define the main directory
MAIL_DIR="/home/info/Maildir"

# Define the directory for the specific user
INFO_DIR="/home/info/Maildir/info@juansilvaphoto.com/tmp"

# Start Dovecot in the background
echo "Starting Dovecot..."
dovecot &

# Wait for Dovecot to start up properly by checking the process
echo "Waiting for Dovecot to start..."
until pgrep -x "dovecot" > /dev/null; do
  sleep 1
done
echo "Dovecot started successfully."

# Create the main mail directory if it doesn't exist
if [ ! -d "$MAIL_DIR" ]; then
  echo "Creating directory $MAIL_DIR"
  mkdir -p "$MAIL_DIR" || { echo "Failed to create $MAIL_DIR"; exit 1; }
fi

# Adjust ownership and permissions for the main mail directory
echo "Setting permissions and ownership for $MAIL_DIR"
chown -R $USER:$GROUP "$MAIL_DIR" && chmod 755 "$MAIL_DIR" || { echo "Failed to set permissions for $MAIL_DIR"; exit 1; }

# Recursively adjust ownership and permissions for all directories and files under $MAIL_DIR
echo "Setting permissions and ownership for all directories and files under $MAIL_DIR"
find "$MAIL_DIR" -type d -exec chown $USER:$GROUP {} \; -exec chmod 755 {} \; || { echo "Failed to set permissions for directories in $MAIL_DIR"; exit 1; }
find "$MAIL_DIR" -type f -exec chown $USER:$GROUP {} \; -exec chmod 644 {} \; || { echo "Failed to set permissions for files in $MAIL_DIR"; exit 1; }

# Check if the specific subdirectory exists and create it if needed
if [ ! -d "$INFO_DIR" ]; then
  echo "Creating directory $INFO_DIR"
  mkdir -p "$INFO_DIR" || { echo "Failed to create $INFO_DIR"; exit 1; }
fi

# Adjust ownership and permissions for the specific directory
echo "Setting permissions and ownership for $INFO_DIR"
chown $USER:$GROUP "$INFO_DIR" && chmod 755 "$INFO_DIR" || { echo "Failed to set permissions for $INFO_DIR"; exit 1; }

# Verify the results
echo "Verification of permissions and ownership:"
ls -ld "$MAIL_DIR"
ls -ld "$INFO_DIR"

echo "Permissions and ownership have been set."
