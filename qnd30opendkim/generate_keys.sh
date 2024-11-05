#!/bin/bash

# Directorio donde se crearán las claves DKIM
KEY_DIR="/etc/opendkim/keys"
DOMAIN="juansilvaphoto.com"
SELECTOR="default"

# Crear el directorio si no existe
mkdir -p "$KEY_DIR"

# Generar las claves DKIM y guardar la salida
opendkim-genkey -D "$KEY_DIR" -d "$DOMAIN" -s "$SELECTOR"

# Cambiar permisos de las claves generadas
chown -R opendkim:opendkim "$KEY_DIR"
chown opendkim:opendkim "$KEY_DIR/${SELECTOR}.private"
chmod 600 "$KEY_DIR/${SELECTOR}.private"

# Imprimir las claves generadas, incluyendo la clave pública y privada
echo "Claves DKIM generadas para el dominio: $DOMAIN con selector: $SELECTOR"
echo "Clave pública (public key) que se debe añadir al DNS:"
cat "$KEY_DIR/${SELECTOR}.txt"
echo ""
echo "Clave privada (private key) que se debe configurar en el servidor de correo:"
cat "$KEY_DIR/${SELECTOR}.private"