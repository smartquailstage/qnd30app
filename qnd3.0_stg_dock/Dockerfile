# Use Python 3.11 Alpine image
FROM python:3.11.3-alpine3.18

# Metadata
LABEL maintainer="mau_dev@smartquail.io"

# Environment variables
ENV PYTHONUNBUFFERED 1
ENV GIT_NODE=qnd30app
ENV NODE_VERSION=qnd30_app_stg
ENV NODE_APP_NAME=qnd30_app_stg
ENV USER=qnd30
ENV PATH="/scripts:/py/bin:$PATH"

# Install git
RUN apk add --no-cache git

# Clone repository
RUN git clone https://github.com/smartquailstage/${GIT_NODE}.git

# Copy necessary files
COPY ./requirements.txt /requirements.txt
COPY ./scripts /scripts
COPY ./uwsgi_stage.ini /${NODE_VERSION}/${NODE_APP_NAME}/uwsgi_stage.ini
COPY ./baton.min.js /${NODE_VERSION}/${NODE_APP_NAME}/baton.min.js
COPY ./qnode_ascii-art.txt /${NODE_VERSION}/${NODE_APP_NAME}/qnode_art.txt

# Set working directory
WORKDIR /${NODE_VERSION}/${NODE_APP_NAME}

# Expose port
EXPOSE 9000

# Set up virtual environment and install dependencies
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache \
        postgresql-client \
        build-base curl postgresql-dev gcc musl-dev python3-dev linux-headers \
        libffi-dev py3-cffi py3-cryptography \
        jpeg-dev go zlib-dev libjpeg build-base wget \
        fontconfig ttf-freefont font-noto terminus-font \
        gtk+3.0 pango busybox-extras \
        openssl-dev gettext neofetch && \
    /py/bin/pip install -r /requirements.txt && \
    apk del openssl-dev

# Create user and directories, set permissions
RUN adduser --disabled-password --no-create-home ${USER} && \
    mkdir -p /${NODE_VERSION}/${NODE_APP_NAME}/{static,media,${NODE_APP_NAME}/staticfiles} && \
    mkdir -p /var/log/uwsgi/ && \
    chown -R ${USER}:${USER} /${NODE_VERSION}/${NODE_APP_NAME} /var/log/uwsgi/ /scripts && \
    chmod -R 755 /${NODE_VERSION}/${NODE_APP_NAME} /scripts && \
    chmod -R u+x /scripts/uwsgi.sh && \
    rm /py/lib/python3.11/site-packages/baton/static/baton/app/dist/baton.min.js && \
    cp /${NODE_VERSION}/${NODE_APP_NAME}/baton.min.js /py/lib/python3.11/site-packages/baton/static/baton/app/dist/

# Set time zone
RUN apk add --no-cache --update musl musl-utils musl-locales tzdata && \
    cp /usr/share/zoneinfo/America/Guayaquil /etc/localtime && \
    echo 'export LC_ALL=es_ES.UTF-8' >> /etc/profile.d/locale.sh && \
    sed -i 's|LANG=C.UTF-8|LANG=es_ES.UTF-8|' /etc/profile.d/locale.sh

# Set locale environment variables
ENV TZ=America/Guayaquil
ENV LANG=es_ES.UTF-8
ENV LANGUAGE=es_ES.UTF-8

# Switch to non-root user
USER ${USER}

# Command to run when the container starts
CMD ["uwsgi.sh"]
