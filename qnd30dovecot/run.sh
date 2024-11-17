#!/bin/bash
service postfix start
# Esperar a que Postfix cree los directorios necesarios
tail -f /var/log/mail.log