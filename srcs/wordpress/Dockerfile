FROM debian:bullseye-slim

# システムの更新とPHP関連パッケージのインストール
RUN apt-get update && apt-get install -y \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-intl \
    php7.4-mbstring \
    php7.4-soap \
    php7.4-xml \
    php7.4-zip \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# 必要なディレクトリの作成と権限設定
RUN mkdir -p /run/php /var/www/html /var/log/php7.4-fpm && \
    chown -R www-data:www-data /run/php /var/www/html /var/log/php7.4-fpm && \
    touch /var/log/php7.4-fpm.log && \
    chown www-data:www-data /var/log/php7.4-fpm.log && \
    chmod 755 /var/log/php7.4-fpm && \
    chmod 644 /var/log/php7.4-fpm.log

# WP-CLIのインストール
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && wp --allow-root cli version

# WordPressのダウンロード
WORKDIR /var/www/html
RUN wp core download --allow-root \
    && chown -R www-data:www-data /var/www/html

# PHP-FPM設定の配置
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# セットアップスクリプトのコピーと実行権限の付与
COPY tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

# www-dataユーザーに切り替え
USER www-data

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup.sh"]
CMD ["/usr/sbin/php-fpm7.4", "-F"]