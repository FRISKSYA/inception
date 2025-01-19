# Inception Project

## 概要
42のDockerを使用してWordPress環境を構築するプロジェクト。HTTPS経由でアクセス可能なWordPress環境を作成します。

## セットアップ
1. ソースコードをクローン
```bash
git clone <repository_url>
```

2. ビルドと起動
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
