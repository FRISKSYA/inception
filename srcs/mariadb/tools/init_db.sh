#!/bin/bash
set -x

echo "[DEBUG] Script started at $(date)" >> /tmp/init_debug.log

# 既存のデータを削除して初期化
rm -rf /var/lib/mysql/*
echo "[DEBUG] Starting initialization" >> /tmp/init_debug.log

# データディレクトリの初期化
mysql_install_db --datadir=/var/lib/mysql --user=mysql

# MariaDB起動
mysqld_safe &

# サーバーが起動するまで待機
until mysqladmin ping >/dev/null 2>&1; do
    echo "[DEBUG] Waiting for MariaDB to be ready..."
    sleep 1
done

echo "[DEBUG] Creating database and users"
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# 一時的なMariaDBを停止
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

echo "[DEBUG] Starting MariaDB"
exec mysqld