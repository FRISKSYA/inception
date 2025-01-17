#!/bin/bash

# SSL証明書の生成
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=JP/ST=Tokyo/L=Tokyo/O=42Tokyo/OU=42Tokyo/CN=kfukuhar.42.fr"

# NGINXの実行
exec nginx -g 'daemon off;'