#!/bin/bash

# Asegúrate de que el directorio exista y tenga permisos correctos
sudo mkdir -p /etc/opendkim/keys
sudo chown -R opendkim:opendkim /etc/opendkim/keys
sudo chmod 700 /etc/opendkim/keys

# Generar las claves DKIM con los parámetros correctos (selector y dominio)
echo "Generando las claves DKIM..."
sudo opendkim-genkey -s mailpost -d mailpost.juansilvaphoto.com -b 2048 -v -D /etc/opendkim/keys || { echo "Error: Fallo al generar las claves DKIM"; exit 1; }

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
sudo mkdir -p /etc/opendkim/keys
# Cambiar el propietario y el grupo a 'opendkim'
sudo chown -R opendkim:opendkim /etc/opendkim/keys
# Asegurarse de que el directorio tenga permisos de escritura solo para el usuario
sudo chmod 700 /etc/opendkim/keys

# Cambiar los permisos de las claves generadas
sudo chmod 600 /etc/opendkim/keys/mailpost.private
sudo chmod 644 /etc/opendkim/keys/mailpost.txt

# Cambiar la propiedad de la clave pública para el acceso correcto
sudo chown opendkim:opendkim /etc/opendkim/keys/mailpost.txt

# Permitir que Postfix acceda al socket de OpenDKIM
# Crear el directorio donde se encuentra el socket si no existe
sudo mkdir -p /var/spool/postfix/opendkim

# Dar permisos para que Postfix pueda acceder al socket de OpenDKIM
sudo chown postfix:postfix /var/spool/postfix/opendkim
sudo chmod 750 /var/spool/postfix/opendkim

# Verificar que el socket de OpenDKIM tiene permisos correctos
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
