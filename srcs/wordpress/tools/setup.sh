#!/bin/bash

# WordPressディレクトリの権限設定
chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

# wp-config.phpの設定
if [ ! -f /var/www/html/wordpress/wp-config.php ]; then
    cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
    
    # データベース設定の更新
    sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wordpress/wp-config.php
    sed -i "s/username_here/$MYSQL_USER/" /var/www/html/wordpress/wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/" /var/www/html/wordpress/wp-config.php
    sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wordpress/wp-config.php

    # ユニークキーの設定
    KEYS=(
        AUTH_KEY
        SECURE_AUTH_KEY
        LOGGED_IN_KEY
        NONCE_KEY
        AUTH_SALT
        SECURE_AUTH_SALT
        LOGGED_IN_SALT
        NONCE_SALT
    )

    for KEY in "${KEYS[@]}"; do
        RANDOM_KEY=$(openssl rand -hex 64)
        sed -i "s/define( '$KEY',.*);/define( '$KEY', '$RANDOM_KEY' );/" /var/www/html/wordpress/wp-config.php
    done
fi

# PHP-FPMの起動
exec "$@"