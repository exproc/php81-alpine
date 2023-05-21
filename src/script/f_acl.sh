#!/bin/sh
setfacl -m g:10001:rwx /test
supervisord -c  /etc/supervisord.conf
exec "$@"