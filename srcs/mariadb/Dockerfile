# wordpressのデータベースってどこでどうやって設定しているの？？？
# docker-composeのボリュームの設定ってデータベースと同義？（おそらく異なる）
# Dockerfileのデータベースのディレクトリ設定がシェルと整合とれてないかも

FROM debian:bullseye

# システムのアップデートとMariaDBのインストール
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# MariaDB設定ファイルのコピー
COPY ./conf/my.cnf /etc/mysql/my.cnf

# 初期化スクリプトのコピー
COPY ./tools/init_db.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init_db.sh

# データベースディレクトリの作成
RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

EXPOSE 3306

ENTRYPOINT ["init_db.sh"]

CMD ["mysqld"]