#!/bin/bash
set -e

# データベースの準備を待機する関数
wait_for_db() {
    max_attempts=30
    attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if mysqladmin ping -h"$WORDPRESS_DB_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; then
            return 0
        fi
        echo "Waiting for database connection... (Attempt $attempt/$max_attempts)"
        sleep 2
        attempt=$(( attempt + 1 ))
    done
    
    echo "Database connection failed after $max_attempts attempts"
    return 1
}

# WordPressのセットアップ
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --path=/var/www/html \
        --skip-check \
        --allow-root

    echo "Waiting for database..."
    wait_for_db

    echo "Installing WordPress core..."
    wp core install \
        --path=/var/www/html \
        --url="$WORDPRESS_URL" \
        --title="WordPress Site" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --skip-email

    echo "Creating editor user..."
    wp user create "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" \
        --role=editor \
        --user_pass="$WORDPRESS_USER_PASSWORD" \
        --path=/var/www/html
fi

echo "Starting PHP-FPM..."
exec "$@"