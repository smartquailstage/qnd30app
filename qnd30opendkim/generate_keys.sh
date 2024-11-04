#!/bin/bash

# Definir dominio y selector
DOMAIN="juansilvaphoto.com"
SELECTOR="default"

# Crear claves DKIM
if [ ! -f "/etc/opendkim/keys/${SELECTOR}.private" ]; then
    opendkim-genkey -s $SELECTOR -d $DOMAIN -D /etc/opendkim/keys
    chown opendkim:opendkim /etc/opendkim/keys/${SELECTOR}.private
    chmod 600 /etc/opendkim/keys/${SELECTOR}.private
    echo "Claves DKIM generadas para $DOMAIN con selector $SELECTOR"
else
    echo "Las claves DKIM ya existen."
fi
