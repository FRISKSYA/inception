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
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# セットアップスクリプトをコピー
COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

# ポート443を公開
EXPOSE 443

# セットアップスクリプトを実行
ENTRYPOINT ["/usr/local/bin/setup.sh"]