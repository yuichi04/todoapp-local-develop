#!/bin/bash

# サブモジュールの初期化と更新
git submodule update --init --recursive

# Dockerコンテナのビルドと起動
docker compose up -d