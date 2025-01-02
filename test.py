# -*- coding: utf-8 -*-

import smtplib

# Configuración del servidor SMTP
smtp_server = "mailpost.juansilvaphoto.com"
smtp_port = 587  # Cambia el puerto si es necesario (25, 465, etc.)
username = "info@juansilvaphoto.com"
password = "A1T2J3C42024"

try:
    # Conexión al servidor SMTP
    server = smtplib.SMTP(smtp_server, smtp_port)
    server.set_debuglevel(1)  # Muestra información detallada del proceso
    server.starttls()  # Inicia la conexión segura TLS
    server.login(username, password)
    print("Conexión exitosa y autenticación completada.")
    server.quit()
except Exception as e:
    print("Error al conectar al servidor SMTP: {}".format(e))
