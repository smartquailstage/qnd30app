# Usar la imagen oficial de Python 3.12 basada en Alpine
FROM python:3.12-alpine

# Metadata
LABEL maintainer="mau_dev@smartquail.io"

# Variables de entorno
ENV PYTHONUNBUFFERED 1
ENV GIT_NODE=qnd30app
ENV NODE_VERSION=qnd30app
ENV NODE_APP_NAME=qnd30_app_stg
ENV USER=qnd30
ENV PATH="/scripts:/py/bin:$PATH"

# Instalar git y las dependencias de construcción necesarias
RUN apk add --no-cache \
    git \
    postgresql-client \
    build-base \
    curl \
    postgresql-dev \
    gcc \
    musl-dev \
    python3-dev \
    linux-headers \
    libffi-dev \
    py3-cffi \
    py3-cryptography \
    jpeg-dev \
    go \
    zlib-dev \
    libjpeg \
    wget \
    fontconfig \
    ttf-freefont \
    font-noto \
    terminus-font \
    gtk+3.0 \
    pango \
    busybox-extras \
    openssl-dev \
    gettext \
    tzdata && \
    # Crear un entorno virtual y actualizar pip
    python -m venv /py && \
    /py/bin/pip install --upgrade pip

# Clonar el repositorio y copiar archivos necesarios
RUN git clone https://github.com/smartquailstage/${GIT_NODE}.git /${NODE_VERSION}/${NODE_APP_NAME}

# Copiar los archivos del proyecto al contenedor
COPY ./requirements.txt /requirements.txt
COPY ./scripts /scripts
COPY ./uwsgi_stage.ini /${NODE_VERSION}/${NODE_APP_NAME}/uwsgi_stage.ini
COPY ./baton.min.js /${NODE_VERSION}/${NODE_APP_NAME}/baton.min.js
COPY ./qnode_ascii-art.txt /${NODE_VERSION}/${NODE_APP_NAME}/qnode_art.txt

# Establecer el directorio de trabajo
WORKDIR /${NODE_VERSION}/${NODE_APP_NAME}

# Exponer el puerto para uwsgi
EXPOSE 9000

# Instalar las dependencias de Python
RUN /py/bin/pip install -r /requirements.txt

# Eliminar las dependencias de construcción innecesarias para reducir el tamaño de la imagen
RUN apk del build-base musl-dev python3-dev gcc libffi-dev py3-cffi py3-cryptography jpeg-dev go zlib-dev libjpeg fontconfig ttf-freefont terminus-font gtk+3.0 pango busybox-extras openssl-dev gettext

# Crear el usuario sin contraseña y asegurarse de que tenga permisos de escritura en los directorios adecuados
RUN adduser --disabled-password --no-create-home ${USER} && \
    mkdir -p /${NODE_VERSION}/${NODE_APP_NAME}/{static,media,${NODE_APP_NAME}/staticfiles} && \
    mkdir -p /var/log/uwsgi/ && \
    chown -R ${USER}:${USER} /${NODE_VERSION}/${NODE_APP_NAME} /var/log/uwsgi/ /scripts && \
    chmod -R 755 /${NODE_VERSION}/${NODE_APP_NAME} /scripts && \
    chmod -R u+x /scripts/uwsgi.sh && \
    # Asegurarse de que el usuario tenga acceso de escritura en `site-packages`
    chown -R ${USER}:${USER} /py/lib/python3.12/site-packages && \
    rm /py/lib/python3.12/site-packages/baton/static/baton/app/dist/baton.min.js && \
    cp /${NODE_VERSION}/${NODE_APP_NAME}/baton.min.js /py/lib/python3.12/site-packages/baton/static/baton/app/dist/

# Configurar la zona horaria
RUN cp /usr/share/zoneinfo/America/Guayaquil /etc/localtime && \
    echo 'export LC_ALL=es_ES.UTF-8' >> /etc/profile.d/locale.sh && \
    sed -i 's|LANG=C.UTF-8|LANG=es_ES.UTF-8|' /etc/profile.d/locale.sh

# Establecer variables de entorno para la localización
ENV TZ=America/Guayaquil
ENV LANG=es_ES.UTF-8
ENV LANGUAGE=es_ES.UTF-8

# Cambiar al usuario no root
USER ${USER}

# Comando para ejecutar cuando el contenedor inicie
CMD ["uwsgi.sh"]
