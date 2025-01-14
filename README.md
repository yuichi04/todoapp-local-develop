# ToDo アプリケーション環境構築ガイド

## 前提条件

以下のツールがインストールされている必要があります：

- Docker
- Docker Compose
- Git

## 初期セットアップ手順

### 1. リポジトリのクローン

```bash
git clone git@github.com:yuichi04/todoapp-local-develop.git
cd todoapp-local-develop
```

### 2. 環境変数の設定

1. `.env.example`ファイルを`.env`にコピー

```bash
cp .env.example .env
```

2. `.env`ファイルを編集し、必要な環境変数を設定

```env
# Database settings
POSTGRES_USER=postgres
POSTGRES_PW=postgres
POSTGRES_HOST=db
POSTGRES_PORT=5432
POSTGRES_DB=postgres
GO_ENV=dev

# PgAdmin settings
PGADMIN_DEFAULT_EMAIL=your_email@example.com
PGADMIN_DEFAULT_PASSWORD=your_password
```

### 3. 開発環境の起動

以下のコマンドを実行して開発環境を起動します：

```bash
./setup.sh
```

このスクリプトは以下の処理を自動的に実行します：

- サブモジュールの初期化と更新
- 各サブモジュールを main ブランチに切り替え
- Docker コンテナのビルドと起動
- データベースマイグレーションの実行

## アクセス方法

各サービスには以下の URL でアクセスできます：

- フロントエンド: http://localhost:3000
- バックエンド API: http://localhost:8080
  - `/test`にアクセスして`Test endpoint working!`が表示されるか確認してください 
- PgAdmin: http://localhost:5050
  - サーバーログインには`.env`ファイルで設定した`PGADMIN_DEFAULT_PASSWOR`を使用　※PgAdmin のログイン自体はスキップされるようになってます

## Docker 構成

プロジェクトは以下のコンテナで構成されています：

- `todoapp-client`: フロントエンドアプリケーション（React）
- `todoapp-api`: バックエンド API（Go）
- `db`: PostgreSQL データベース
- `pgadmin`: データベース管理ツール

## トラブルシューティング

### セットアップスクリプトでエラーが発生する場合

1. コンテナの状態を確認

```bash
docker compose ps
```

2. 各サービスのログを確認

```bash
# データベースのログ
docker compose logs db

# APIサーバーのログ
docker compose logs todoapp-api
```

3. 環境を完全にリセットして再試行

```bash
docker compose down -v
./setup.sh
```

### PgAdmin にアクセスできない場合

- コンテナの起動完了後 1-2 分待つ
- ブラウザのキャッシュをクリア
- 別のブラウザでアクセスを試す

## 開発環境の停止

```bash
docker compose down
```

データベースの永続化データを含めて完全に環境を削除する場合：

```bash
docker compose down -v
```

## 注意事項

- データベースのデータは`postgres-data`ボリュームに永続化されています
- 環境変数は`.env`ファイルで管理され、このファイルはバージョン管理対象外です
- 本番環境用の設定は含まれていません。これは開発環境専用の設定です

## ヘルプとサポート

問題が発生した場合は、以下を確認してください：

1. すべてのコンテナが正常に起動しているか
2. 環境変数が正しく設定されているか
3. 必要なポートが他のアプリケーションで使用されていないか

各種ログの確認方法や、一般的な問題の解決方法については、上記のトラブルシューティングセクションを参照してください。
