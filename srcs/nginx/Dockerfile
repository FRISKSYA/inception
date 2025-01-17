FROM debian:bullseye

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# SSL証明書用のディレクトリ作成
RUN mkdir -p /etc/nginx/ssl

# NGINXの設定ファイルをコピー
COPY ./conf/nginx.conf.template /etc/nginx/conf.d/nginx.conf.template

# セットアップスクリプトをコピー
COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

# テスト用のHTMLファイルを作成
RUN mkdir -p /var/www/html
RUN echo "<!DOCTYPE html><html><body><h1>NGINX with SSL is working!</h1></body></html>" > /var/www/html/index.html

# ポート443を公開
EXPOSE 443

# セットアップスクリプトを実行
ENTRYPOINT ["/usr/local/bin/setup.sh"]