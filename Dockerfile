FROM ghcr.io/exproc/base

ARG MODS_VERSION="v3"
ARG PKG_INST_VERSION="v1"

ADD --chmod=744 "https://raw.githubusercontent.com/linuxserver/docker-mods/mod-scripts/docker-mods.${MODS_VERSION}" "/docker-mods"
ADD --chmod=744 "https://raw.githubusercontent.com/linuxserver/docker-mods/mod-scripts/package-install.${PKG_INST_VERSION}" "/etc/s6-overlay/s6-rc.d/init-mods-package-install/run"

ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
  HOME="/root" \
  TERM="xterm" \
  S6_CMD_WAIT_FOR_SERVICES_MAXTIME="0" \
  S6_VERBOSITY=1 \
  S6_STAGE2_HOOK=/docker-mods \
  VIRTUAL_ENV=/lsiopy \
  PATH="/lsiopy/bin:$PATH"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache  \
    s6 \
    s6-overlay \
    openssl \
    php81-bcmath \
    php81-bz2 \
    php81-ctype \
    php81-curl \
    php81-dom \
    php81-exif \
    php81-ftp \
    php81-gd \
    php81-gmp \
    php81-iconv \
    php81-imap \
    php81-intl \
    php81-ldap \
    php81-mysqli \
    php81-mysqlnd \
    php81-opcache \
    php81-pdo_mysql \
    php81-pdo_odbc \
    php81-pdo_pgsql \
    php81-pdo_sqlite \
    php81-pear \
    php81-pecl-apcu \
    php81-pecl-mailparse \
    php81-pecl-memcached \
    php81-pecl-redis \
    php81-pgsql \
    php81-phar \
    php81-posix \
    php81-soap \
    php81-sockets \
    php81-sodium \
    php81-sqlite3 \
    php81-tokenizer \
    php81-xmlreader \
    php81-xsl \
    php81-zip \
    php81-fpm\
    openssl \
    logrotate \
    nginx && \
    apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    php81-pecl-mcrypt \
    php81-pecl-xmlrpc \
    php81-gettext \
    tftp-hpa \
    php81-pecl-imagick && \
 echo "**** configure nginx ****" && \
  echo 'fastcgi_param  HTTP_PROXY         ""; # https://httpoxy.org/' >> \
    /etc/nginx/fastcgi_params && \
  echo 'fastcgi_param  PATH_INFO          $fastcgi_path_info; # http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_split_path_info' >> \
    /etc/nginx/fastcgi_params && \
  echo 'fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name; # https://www.nginx.com/resources/wiki/start/topics/examples/phpfcgi/#connecting-nginx-to-php-fpm' >> \
    /etc/nginx/fastcgi_params && \
  echo 'fastcgi_param  SERVER_NAME        $host; # Send HTTP_HOST as SERVER_NAME. If HTTP_HOST is blank, send the value of server_name from nginx (default is `_`)' >> \
    /etc/nginx/fastcgi_params && \
  rm -f /etc/nginx/conf.d/stream.conf && \
  rm -f /etc/nginx/http.d/default.conf && \
  echo "**** configure php ****" && \
  sed -i "s#;error_log = log/php81/error.log.*#error_log = /config/log/php/error.log#g" \
    /etc/php81/php-fpm.conf && \
  sed -i "s#user = nobody.*#user = abc#g" \
    /etc/php81/php-fpm.d/www.conf && \
  sed -i "s#group = nobody.*#group = abc#g" \
    /etc/php81/php-fpm.d/www.conf && \
  echo "**** fix logrotate ****" && \
  sed -i "s#/var/log/messages {}.*# #g" \
    /etc/logrotate.conf && \
  sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' \
    /etc/periodic/daily/logrotate
   
COPY root/ /
ENTRYPOINT ["/init"] 
# ports and volumes

VOLUME /config

EXPOSE 80 443 