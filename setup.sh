#!/bin/bash

# サブモジュールの初期化と更新
git submodule update --init --recursive

# 各サブモジュールをmainブランチに切り替え
git submodule foreach 'git checkout main && git pull origin main'

# Dockerコンテナのビルドと起動
docker compose up -d