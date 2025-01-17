FROM debian:bullseye-slim

# 必要なパッケージのインストール
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
    wget \
    && rm -rf /var/lib/apt/lists/*

# WordPressのダウンロードと配置
WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzvf latest.tar.gz && \
    rm latest.tar.gz && \
    chown -R www-data:www-data /var/www/html/wordpress

# PHP-FPM設定の配置
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# PHP-FPMのソケットディレクトリを作成
RUN mkdir -p /run/php && \
    chown www-data:www-data /run/php

# セットアップスクリプトのコピーと実行権限の付与
COPY tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 9000

ENTRYPOINT ["setup.sh"]
CMD ["/usr/sbin/php-fpm7.4", "-F"]