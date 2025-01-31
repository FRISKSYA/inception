FROM debian:bullseye-slim

# パッケージのインストールと必要なディレクトリの作成、WordPressのセットアップを1つのRUNで実行
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
   curl \
   lsb-release \
   apt-transport-https \
   ca-certificates \
   && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
   && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list \
   && apt-get update \
   && rm -rf /var/lib/apt/lists/* \
   && mkdir -p /run/php /var/www/html \
   && chown www-data:www-data /run/php \
   && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
   && chmod +x wp-cli.phar \
   && mv wp-cli.phar /usr/local/bin/wp \
   && cd /var/www/html \
   && wget https://wordpress.org/latest.tar.gz \
   && tar -xzvf latest.tar.gz \
   && rm latest.tar.gz \
   && chown -R www-data:www-data /var/www/html/wordpress

# PHP-FPM設定の配置
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# セットアップスクリプトのコピーと実行権限の付与
COPY tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["setup.sh"]
CMD ["/usr/sbin/php-fpm7.4", "-F"]