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
    # =====
    # AUTH_KEY と AUTH_SALT
    # - ユーザー認証のためのメインキーとソルト
    # - ログイン時の認証に使用
    # SECURE_AUTH_KEY と SECURE_AUTH_SALT
    # - セキュアな認証のためのキーとソルト
    # - HTTPS接続時の認証に使用
    # LOGGED_IN_KEY と LOGGED_IN_SALT
    # - ログイン済みユーザーのセッション管理に使用
    # - ログインクッキーの暗号化に利用
    # NONCE_KEY と NONCE_SALT
    # - フォーム送信時のCSRF（クロスサイトリクエストフォージェリ）対策に使用
    # - 一時的なトークンの生成に利用
    # これらのキーとソルトは：
    # - ユーザーセッションの暗号化
    # - クッキーの暗号化
    # - ワンタイムトークンの生成に使用され、サイトのセキュリティを強化
    # =====
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

    # WordPressのインストールとユーザー作成を待機
    # TODO: ヘルスチェックに置換するべき
    sleep 10

    # WordPressのコアインストール
    cd /var/www/html/wordpress
    wp core install --path=/var/www/html/wordpress \
        --url=${WORDPRESS_URL} \
        --title="WordPress Site" \
        --admin_user=${WORDPRESS_ADMIN_USER} \
        --admin_password=${WORDPRESS_ADMIN_PASSWORD} \
        --admin_email=${WORDPRESS_ADMIN_EMAIL} \
        --skip-email \
        --allow-root

    # 通常ユーザーの作成
    wp user create ${WORDPRESS_USER} ${WORDPRESS_USER_EMAIL} \
        --role=author \
        --user_pass=${WORDPRESS_USER_PASSWORD} \
        --path=/var/www/html/wordpress \
        --allow-root
fi

# PHP-FPMの起動
exec "$@"