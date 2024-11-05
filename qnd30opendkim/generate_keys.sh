#!/bin/bash

# Asegúrate de que el directorio exista
mkdir -p /etc/opendkim/keys

# Generar las claves DKIM (ajustar el dominio y selector según sea necesario)
opendkim-genkey -b 2048 -d juansilvaphoto.com -s default -v

# Cambiar permisos para la clave privada
chown opendkim:opendkim /etc/opendkim/keys/default.private
chmod 600 /etc/opendkim/keys/default.private

# Generar la clave pública para agregarla al DNS
chown opendkim:opendkim /etc/opendkim/keys/default.txt

# Mostrar las claves generadas
cat /etc/opendkim/keys/default.txt
cat /etc/opendkim/keys/default.private
