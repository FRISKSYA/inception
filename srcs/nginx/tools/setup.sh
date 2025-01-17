#!/bin/bash

# SSL証明書の生成
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=JP/ST=Tokyo/L=Tokyo/O=42Tokyo/CN=${DOMAIN_NAME}"

# テンプレートから設定ファイルを生成
envsubst '${DOMAIN_NAME}' < /etc/nginx/conf.d/nginx.conf.template > /etc/nginx/conf.d/default.conf

# NGINXを起動
exec nginx -g 'daemon off;'