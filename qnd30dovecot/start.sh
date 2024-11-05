#!/bin/bash

# Define el usuario y grupo
USER="vmail"
GROUP="vmail"

# Define el directorio principal
MAIL_DIR="/home/info/Maildir"
INFO_DIR="$MAIL_DIR/tmp"

# Verificar si Dovecot ya está en ejecución y eliminar el archivo de PID si es necesario
if pidof dovecot > /dev/null; then
    echo "Dovecot is already running."
else
    echo "Starting Dovecot..."
    # Eliminar cualquier archivo PID huérfano
    rm -f /run/dovecot/master.pid
    # Iniciar Dovecot en primer plano para que Docker pueda gestionarlo correctamente
    dovecot -F &  # Usamos -F para mantener Dovecot en primer plano
    # Esperar unos segundos para asegurarse de que Dovecot se haya iniciado correctamente
    sleep 10
fi

# Crear el directorio principal si no existe
if [ ! -d "$MAIL_DIR" ]; then
    echo "Creating $MAIL_DIR..."
    mkdir -p "$MAIL_DIR"
else
    echo "$MAIL_DIR already exists."
fi

# Ajustar propiedad y permisos para el directorio principal de correo
echo "Setting permissions and ownership for $MAIL_DIR"
chown -R $USER:$GROUP "$MAIL_DIR"
chmod 700 "$MAIL_DIR"  # Permisos restringidos para el maildir (solo el usuario puede acceder)

# Ajustar propiedad y permisos recursivamente para todos los directorios y archivos dentro de Maildir
echo "Setting permissions and ownership for all directories and files under $MAIL_DIR"
find "$MAIL_DIR" -type d -exec chown $USER:$GROUP {} \; -exec chmod 700 {} \;  # Los directorios deben ser 700 (acceso solo para el usuario)
find "$MAIL_DIR" -type f -exec chown $USER:$GROUP {} \; -exec chmod 600 {} \;  # Los archivos deben ser 600 (solo el usuario puede leer y escribir)

# Comprobar si el directorio tmp dentro de Maildir existe; crearlo si es necesario
if [ ! -d "$INFO_DIR" ]; then
    echo "Creating $INFO_DIR..."
    mkdir -p "$INFO_DIR"
else
    echo "$INFO_DIR already exists."
fi

# Ajustar propiedad y permisos para el directorio tmp específico
echo "Setting permissions and ownership for $INFO_DIR"
chown $USER:$GROUP "$INFO_DIR"
chmod 700 "$INFO_DIR"  # Permisos restringidos para tmp (acceso solo para el usuario)

# Verificar los resultados
echo "Verification of permissions and ownership:"
ls -ld "$MAIL_DIR"
ls -ld "$INFO_DIR"

echo "Permissions and ownership have been set."
