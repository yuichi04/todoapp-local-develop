#!/bin/bash

# サブモジュールの初期化と更新
git submodule update --init --recursive

# 各サブモジュールをmainブランチに切り替え
git submodule foreach 'git checkout main && git pull origin main'

# Dockerコンテナのビルドと起動
docker compose up -d

# データベースの準備ができるまで待機
echo "Waiting for database to be ready..."
until docker compose exec db pg_isready -U postgres; do
  echo "Database is unavailable - sleeping"
  sleep 1
done
echo "Database is ready!"

# マイグレーションの実行
echo "Running migrations..."
docker compose exec todoapp-api go run migrate/migrate.go