#!/bin/bash

# Asegúrate de que el directorio exista y tenga permisos correctos
mkdir -p /etc/opendkim/keys
chown -R opendkim:opendkim /etc/opendkim/keys
chmod 700 /etc/opendkim/keys

# Generar las claves DKIM con los parámetros correctos (selector y dominio)
echo "Generando las claves DKIM..."
opendkim-genkey -s mailpost -d juansilvaphoto.com -b 2048 -v -D /etc/opendkim/keys || { echo "Error: Fallo al generar las claves DKIM"; exit 1; }

# Verificar que las claves hayan sido generadas
if [ ! -f /etc/opendkim/keys/mailpost.private ]; then
    echo "Error: No se encontró la clave privada mailpost.private"
    exit 1
fi

if [ ! -f /etc/opendkim/keys/mailpost.txt ]; then
    echo "Error: No se encontró la clave pública mailpost.txt"
    exit 1
fi

# Crear el directorio para las claves DKIM si no existe
mkdir -p /etc/opendkim/keys
# Cambiar el propietario y el grupo a 'opendkim'
chown -R opendkim:opendkim /etc/opendkim/keys
# Asegurarse de que el directorio tenga permisos de escritura solo para el usuario
chmod 700 /etc/opendkim/keys

# Cambiar los permisos de las claves generadas
chmod 600 /etc/opendkim/keys/mailpost.private
chmod 644 /etc/opendkim/keys/mailpost.txt

# Cambiar la propiedad de la clave pública para el acceso correcto
chown opendkim:opendkim /etc/opendkim/keys/mailpost.txt

# Mostrar las claves generadas
echo "Clave pública DKIM:"
cat /etc/opendkim/keys/mailpost.txt

echo "Clave privada DKIM:"
cat /etc/opendkim/keys/mailpost.private

echo "Las claves DKIM se generaron correctamente."
