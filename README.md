# Inception Project

## 概要
42のDockerを使用してWordPress環境を構築するプロジェクト。HTTPS経由でアクセス可能なWordPress環境を作成します。

## セットアップ
1. ソースコードをクローン
```bash
git clone <repository_url>
```

2. 環境変数の設定
```bash
cp srcs/.env.example srcs/.env
# .envファイルを編集して必要な環境変数を設定
```
```.env
# MariaDB
MYSQL_ROOT_PASSWORD=
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=

# WordPress設定
WORDPRESS_DB_HOST=mariadb
WORDPRESS_DB_NAME=wordpress
WORDPRESS_URL=https://{your_intra_id}.42.fr
WORDPRESS_ADMIN_USER=superuser
WORDPRESS_ADMIN_PASSWORD=
WORDPRESS_ADMIN_EMAIL=admin@example.com
WORDPRESS_USER=editor
WORDPRESS_USER_PASSWORD=
WORDPRESS_USER_EMAIL=editor@example.com
```

3. ビルドと起動
```bash
make
```

## 使用方法
- HTTPS経由でWordPressにアクセス：https://login.42.fr
- 管理者とユーザーのログイン情報は.envファイルで設定

## 注意事項
- DockerHubのイメージは使用禁止（Alpine/Debian除く）
- latestタグの使用禁止
- Dockerfileにパスワードを記載しない
- コンテナは無限ループで起動しない（tail -f等は使用禁止）

## ディレクトリ構造
```
.
├── Makefile
├── srcs
│   ├── docker-compose.yml
│   ├── .env
│   ├── nginx
│   ├── wordpress
│   └── mariadb
```
