#!/bin/bash

# Asegúrate de que el directorio de claves de OpenDKIM exista y tenga los permisos correctos
mkdir -p /etc/opendkim/keys
chown -R opendkim:opendkim /etc/opendkim/keys
chmod 700 /etc/opendkim/keys

# Generar las claves DKIM con los parámetros correctos (selector y dominio)
echo "Generando las claves DKIM..."
opendkim-genkey -s mailpost -d mailpost.juansilvaphoto.com -b 2048 -v -D /etc/opendkim/keys || { echo "Error: Fallo al generar las claves DKIM"; exit 1; }

# Verificar que las claves hayan sido generadas
if [ ! -f /etc/opendkim/keys/mailpost.private ]; then
    echo "Error: No se encontró la clave privada mailpost.private"
    exit 1
fi

if [ ! -f /etc/opendkim/keys/mailpost.txt ]; then
    echo "Error: No se encontró la clave pública mailpost.txt"
    exit 1
fi

# Cambiar la propiedad y los permisos de las claves generadas
chmod 600 /etc/opendkim/keys/mailpost.private
chmod 644 /etc/opendkim/keys/mailpost.txt
chown opendkim:opendkim /etc/opendkim/keys/mailpost.txt

# Asegurarse de que Postfix tenga acceso al directorio de OpenDKIM
mkdir -p /var/spool/postfix/opendkim
chown postfix:postfix /var/spool/postfix/opendkim
chmod 750 /var/spool/postfix/opendkim

# Verificar que el socket de OpenDKIM tenga los permisos correctos
if [ -S /var/spool/postfix/opendkim/opendkim.sock ]; then
    echo "El socket de OpenDKIM está listo para ser utilizado por Postfix."
else
    echo "Error: El socket de OpenDKIM no se encuentra o tiene permisos incorrectos."
    exit 1
fi

# Mostrar las claves generadas
echo "Clave pública DKIM:"
cat /etc/opendkim/keys/mailpost.txt

echo "Clave privada DKIM:"
cat /etc/opendkim/keys/mailpost.private

echo "Las claves DKIM se generaron correctamente."
