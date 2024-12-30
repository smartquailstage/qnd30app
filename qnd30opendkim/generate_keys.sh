#!/bin/bash

# Variables
KEY_DIR="/etc/opendkim/keys"
SOCKET_DIR="/var/spool/postfix/opendkim"
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

# Iniciar el servicio de OpenDKIM para que se cree el socket
echo "Iniciando el servicio OpenDKIM..."
service opendkim start

# Verificar si el socket se creó
if [ -S $SOCKET_DIR/opendkim.sock ]; then
    echo "El socket de OpenDKIM se creó correctamente en $SOCKET_DIR/opendkim.sock"
else
    echo "Error: El socket de OpenDKIM no se creó."
    exit 1
fi

# Mostrar la clave pública para configurar el DNS
echo "Clave pública DKIM:"
cat $KEY_DIR/$SELECTOR.txt
