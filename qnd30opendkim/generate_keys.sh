#!/bin/bash

# Directorio donde se crearán las claves DKIM
KEY_DIR="/etc/opendkim/keys"
DOMAIN="juansilvaphoto.com"
SELECTOR="default"

# Crear el directorio si no existe
mkdir -p $KEY_DIR

# Generar las claves DKIM
opendkim-genkey -D $KEY_DIR -d $DOMAIN -s $SELECTOR

# Cambiar permisos
chown opendkim:opendkim $KEY_DIR/$SELECTOR.private
chmod 600 $KEY_DIR/$SELECTOR.private
