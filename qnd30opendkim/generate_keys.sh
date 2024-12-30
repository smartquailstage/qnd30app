#!/bin/bash

# Directorio donde se almacenarán las claves
KEY_DIR="/etc/opendkim/keys"
DOMAIN="mailpost.juansilvaphoto.com"
SELECTOR="mail"

# Crear el directorio de claves si no existe
mkdir -p $KEY_DIR

# Generar las claves DKIM
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
