FROM node:argon-slim
# Em 2016-01-08 corresponde a 4.2.4-slim

MAINTAINER João Antonio Ferreira "joao.parana@gmail.com"

ENV REFRESHED_AT 2016-01-08
ENV NODE_VERSION=4.2.4
ENV PRIMARYGRP dev
ENV MYGROUP webcomponents
ENV USER_NAME dev

# O git e suas dependências ocupa 70 Megas
# Optei por usar --no-install-recommends para diminuir para 58 Megas
RUN apt-get update && apt-get install -y --no-install-recommends git \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app/webcomponents/

RUN git clone https://github.com/joao-parana/time-elements.git

WORKDIR /app/webcomponents/time-elements

RUN echo "••• `date` - Executando npm install" && \
    npm install && \
    echo "••• `date` - Instalando o Bower" && \
    npm install -g bower && \
    echo "••• `date` - Instalando o Polyserve" && \
    npm install -g polyserve && \
    touch /.app-instaled

COPY run-npm-and-bower /run-npm-and-bower
COPY ssh-keys /ssh-keys

RUN groupadd $MYGROUP && \
    groupadd $PRIMARYGRP && \
    useradd $USER_NAME -s /bin/bash -m -g $PRIMARYGRP -G $MYGROUP && \
    mkdir -p /home/$USER_NAME/.ssh && \
    cp /ssh-keys/* /home/$USER_NAME/.ssh/ && \
    chown -R $USER_NAME:$PRIMARYGRP /app

USER $USER_NAME

ENTRYPOINT ["/run-npm-and-bower"]
