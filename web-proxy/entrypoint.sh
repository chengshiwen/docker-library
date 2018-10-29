#!/bin/sh

if [[ "${1#-}" != "$1" ]]; then
    set -- nginx -g 'daemon off;' "$@"
fi

export WEB_ROOT_DIR=${WEB_ROOT_DIR:-/usr/share/nginx/html}
export WEB_LOG_DIR=${WEB_LOG_DIR:-/var/log/web}

if [[ -f ${WEB_ROOT_DIR}/static/js/config.js.template ]]; then
    envsubst < ${WEB_ROOT_DIR}/static/js/config.js.template > ${WEB_ROOT_DIR}/static/js/config.js
elif [[ ! -d ${WEB_ROOT_DIR} ]]; then
    mkdir -p ${WEB_ROOT_DIR}
fi

if [[ -n ${WEB_LOG_DIR} ]]; then
    mkdir -p -m 777 ${WEB_LOG_DIR}
    envsubst < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
fi

exec "$@"
