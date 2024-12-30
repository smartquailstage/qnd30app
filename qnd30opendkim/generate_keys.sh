#!/bin/bash

# Variables
KEY_DIR="/etc/opendkim/keys"
SOCKET_DIR="/var/spool/postfix/opendkim"
SOCKET="$SOCKET_DIR/opendkim.sock"
DOMAIN="mailpost.juansilvaphoto.com"
SELECTOR="mail"

# Crear el directorio de claves si no existe
mkdir -p $KEY_DIR

# Crear el directorio del socket si no existe
mkdir -p $SOCKET_DIR

# Asignar el propietario y permisos necesarios para el directorio del socket
chown opendkim:postfix $SOCKET_DIR
chmod 750 $SOCKET_DIR

# Generar las claves DKIM
echo "Generando las claves DKIM..."
opendkim-genkey -s $SELECTOR -d $DOMAIN -b 2048 -v -D $KEY_DIR

# Verificar si las claves se generaron correctamente
if [ ! -f $KEY_DIR/$SELECTOR.private ]; then
    echo "Error: No se encontró la clave privada $KEY_DIR/$SELECTOR.private"
    exit 1
fi

if [ ! -f $KEY_DIR/$SELECTOR.txt ]; then
    echo "Error: No se encontró la clave pública $KEY_DIR/$SELECTOR.txt"
    exit 1
fi

echo "Claves DKIM generadas correctamente."

# Iniciar el servicio de OpenDKIM
echo "Iniciando el servicio OpenDKIM..."
service opendkim start

# Pausar brevemente para dar tiempo a que se cree el socket
sleep 2

# Verificar si el socket se creó
if [ -S $SOCKET ]; then
    echo "El socket de OpenDKIM se creó correctamente en $SOCKET"
else
    echo "Error: El socket de OpenDKIM no se creó."
    exit 1
fi

# Mostrar la clave pública para configurar el DNS
echo "Clave pública DKIM:"
cat $KEY_DIR/$SELECTOR.txt
