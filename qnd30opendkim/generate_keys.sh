#!/bin/bash

# Asegúrate de que el directorio exista y tenga permisos correctos
mkdir -p /etc/opendkim/keys
chown -R opendkim:opendkim /etc/opendkim/keys
chmod 700 /etc/opendkim/keys

# Generar las claves DKIM con los parámetros correctos (selector y dominio)
echo "Generando las claves DKIM..."
opendkim-genkey -s mailpost -d juansilvaphoto.com -b 2048 -v -D /etc/opendkim/keys || { echo "Error: Fallo al generar las claves DKIM"; exit 1; }

# Verificar que las claves hayan sido generadas
if [ ! -f /etc/opendkim/keys/mailpost.juansilvaphoto.com.private ]; then
    echo "Error: No se encontró la clave privada mailpost.juansilvaphoto.com.private"
    exit 1
fi

if [ ! -f /etc/opendkim/keys/mailpost.juansilvaphoto.com.txt ]; then
    echo "Error: No se encontró la clave pública mailpost.juansilvaphoto.com.txt"
    exit 1
fi

# Cambiar los permisos de las claves generadas
chmod 600 /etc/opendkim/keys/mailpost.juansilvaphoto.com.private
chmod 644 /etc/opendkim/keys/mailpost.juansilvaphoto.com.txt

# Cambiar la propiedad de la clave pública para el acceso correcto
chown opendkim:opendkim /etc/opendkim/keys/mailpost.juansilvaphoto.com.txt

# Mostrar las claves generadas
echo "Clave pública DKIM:"
cat /etc/opendkim/keys/mailpost.juansilvaphoto.com.txt

echo "Clave privada DKIM:"
cat /etc/opendkim/keys/mailpost.juansilvaphoto.com.private

echo "Las claves DKIM se generaron correctamente."
