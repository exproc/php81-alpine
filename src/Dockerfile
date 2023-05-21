FROM ghcr.io/exproc/base-alpine-e
LABEL Maintainer="Chris c <chris@cchalifo.xyz>"
LABEL Description="Alpine Linux edge Php 8.1"
RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache  \
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
    acl && \
    apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    php81-pecl-mcrypt \
    php81-pecl-xmlrpc \
    php81-gettext \
    php81-pecl-imagick
   
  RUN addgroup -g 10001 smbw  
  RUN  mkdir -pv /test 
  ADD src/supervisor.d/nginx.ini  /etc/supervisor.d/
  ADD src/supervisor.d/php-fmp-81.ini /etc/supervisor.d/
  #RUN rm /etc/supervisor.d/Fix-permission.ini
  #RUN  setfacl -m g:10001:rwx /test/
  #RUN getfacl /test/
  RUN ls -la /etc/supervisor.d/
  COPY src/script/ /
  COPY src/etc/nginx/default.conf /etc/nginx/http.d/
  COPY src/php81/conf.d/custom.ini /etc/php81/conf.d/
  COPY src/php81/php-fpm.d/www.conf /etc/php81/php-fpm.d/
  RUN chmod +x /f_acl.sh && \
  chmod +x /start.sh
  RUN ls -la /
  ADD src/script/start.sh /
  ENTRYPOINT [ "sh" , "/start.sh" ]
  #ENTRYPOINT ["sh", "/f_acl.sh"]
  #CMD ["/usr/bin/supervisord",  "-c", "/etc/supervisord.conf"]pervisord.conf"]
  EXPOSE 9000