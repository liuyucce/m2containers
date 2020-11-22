#!/usr/bin/env bash
set -e

for name in BACKEND_PORT BACKEND_HOST PURGE_HOST_WORKSPACE PURGE_HOST_PHP_FPM
do
    eval value=\$$name
    sed -i "s|\${${name}}|${value}|g" /etc/varnish/default.vcl
done

exec bash -c \
    "exec varnishd \
    -a :$VARNISH_PORT \
    -T localhost:6082 \
    -F \
    -f $VARNISH_CONFIG \
    -s malloc,$CACHE_SIZE \
    $VARNISHD_PARAMS"