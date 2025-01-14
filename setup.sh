#!binbash

# エラー発生時にスクリプトを終了
set -e

echo 🚀 Starting development environment setup...

# 古い環境のクリーンアップ
echo 🧹 Cleaning up ol environment...
docker compose down -v 2devnull  true

# サブモジュールの初期化と更新
echo 📦 Initializing and updating submodules...
git submodule update --init --recursive

# 各サブモジュールをmainブランチに切り替え
echo 🔄 Switching submodules to main branch...
git submodule foreach 'git checkout main && git pull origin main'

# .envファイルの存在確認
if [ ! -f .env]; then
    echo ⚠️ .enc file not found. Creating from .env.example...
    cp .env.example .env  { echo ❌ Error Cloud not create .env file; exit 1; }
fi

# フロントエンドの依存関係をインストール
echo 📚 Installing frontend dependencies...
cd todoapp-client && npm install && cd ..

# Dockerコンテナのビルドと起動
echo 🏗️ Building and starting Docker containers...
docker compose up -d

# データベースの準備ができるまで待機
echo ⏳ Waiting for database to be ready...
timeout=60
elapsed=0
until docker compose exec db pg_isready -U postgres; do
    if [ $elapsed -ge $timeout ]; then
        echo ❌ Timeout waiting for database
        exit 1
    fi
    echo Database is unavailable - sleeping
    sleep 1
    elapsed=$((elapsed+1))
done
echo ✅ Database is ready!

# マイグレーションの実行
echo 🔄 Running database migrations...
docker compose exec todoapp-api go run migratemigrate.go

echo ✨ Setup completed successfully!
echo
    - Frontend httplocalhost3000
    - Backend API httplocalhost8080
    - PgAdmin httplocalhost5050
