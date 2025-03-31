FROM debian:12

USER root

# Установка необходимых пакетов для 1С
RUN echo "deb http://deb.debian.org/debian bookworm contrib" >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y \
    libmagickwand-dev \
    libfontconfig1 \
    libfreetype6 \
    libgsf-1-common\
    libglib2.0-0 \
    libodbc1 \
    libkrb5-3 \
    libgssapi-krb5-2 \
    ttf-mscorefonts-installer \
    && fc-cache -fv \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/distributions

# Копирование пакетов 1С в контейнер
COPY ./distributions/1c-enterprise-8.3*-common_8.3*.deb ./
COPY ./distributions/1c-enterprise-8.3*-server_8.3*.deb ./
COPY ./distributions/1c-enterprise-8.3*-ws_8.3*.deb ./

# Установка сервера 1С и добавление ibsrv и ibcmd в PATH
RUN dpkg -i 1c-enterprise-8.3*-common_8.3*.deb \
    && dpkg -i 1c-enterprise-8.3*-server_8.3*.deb \
    && dpkg -i 1c-enterprise-8.3*-ws_8.3*.deb \
    && rm -rf /tmp/distributions \
    && ln -s /opt/1cv8/x86_64/*/ibsrv /usr/local/bin/ibsrv \
    && ln -s /opt/1cv8/x86_64/*/ibcmd /usr/local/bin/ibcmd

CMD ["bash"]
