#!/bin/bash

# Asegúrate de que el directorio exista y tenga permisos correctos
mkdir -p /etc/opendkim/keys
chown -R opendkim:opendkim /etc/opendkim/keys
chmod 700 /etc/opendkim/keys

# Generar las claves DKIM
opendkim-genkey --bits=2048 --domain=juansilvaphoto.com --selector=default --directory=/etc/opendkim/keys

# Cambiar permisos para la clave privada
chown opendkim:opendkim /etc/opendkim/keys/default.private
chmod 600 /etc/opendkim/keys/default.private

# Generar la clave pública para agregarla al DNS
chown opendkim:opendkim /etc/opendkim/keys/default.txt

# Mostrar las claves generadas
cat /etc/opendkim/keys/default.txt
cat /etc/opendkim/keys/default.private
