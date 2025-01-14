# タスク管理アプリケーション環境構築ガイド

## 前提条件

以下のツールがインストールされている必要があります：

- Docker
- Docker Compose
- Git
- Node.js と npm

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

### 3. setup.shに実行権限を付与

```bash
chmod +x setup.sh
```

または、以下のコマンドで実行することもできます：
```bash
bash setup.sh
```

### 4. 開発環境の起動

以下のコマンドを実行して開発環境を起動します：
```bash
./setup.sh
```

このスクリプトは以下の処理を自動的に実行します：
- 古い環境のクリーンアップ
- サブモジュールの初期化と更新
- 各サブモジュールをmainブランチに切り替え
- フロントエンドの依存関係のインストール（npm install）
- Dockerコンテナのビルドと起動
- データベースマイグレーションの実行

## アクセス方法

各サービスには以下のURLでアクセスできます：

- フロントエンド: http://localhost:3000
- バックエンドAPI: http://localhost:8080
  - `/test`エンドポイントにアクセスして`Test endpoint working!`が表示されることを確認
- PgAdmin: http://localhost:5050
  - ログイン認証は自動的にスキップされます
  - データベース接続情報は環境変数の設定が使用されます

## Docker構成

プロジェクトは以下のコンテナで構成されています：

- `todoapp-client`: フロントエンドアプリケーション（React）
- `todoapp-api`: バックエンドAPI（Go）
- `db`: PostgreSQLデータベース
- `pgadmin`: データベース管理ツール（認証スキップ設定済み）

## トラブルシューティング

### setup.shの実行権限エラー
```bash
-bash: ./setup.sh: cannot execute: required file not found
```
上記のエラーが出た場合は、`chmod +x setup.sh`で実行権限を付与するか、`bash setup.sh`コマンドを使用してください。

### 環境変数の未設定エラー
```
WARN[0000] The "POSTGRES_USER" variable is not set. Defaulting to a blank string.
```
上記のようなエラーが出た場合は、`.env`ファイルが正しく作成され、必要な環境変数が設定されているか確認してください。

### その他のトラブルシューティング

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

### PgAdminにアクセスできない場合
- コンテナの起動完了を1-2分待つ
- ブラウザのキャッシュをクリア
- 別のブラウザでアクセスを試す

## 開発環境の停止

通常の停止：
```bash
docker compose down
```

データベースの永続化データを含めて完全に環境を削除：
```bash
docker compose down -v
```

## 注意事項

- データベースのデータは`postgres-data`ボリュームに永続化されています
- 環境変数は`.env`ファイルで管理され、このファイルはバージョン管理対象外です
- PgAdminの認証はスキップする設定になっていますが、これは開発環境専用の設定です
- 本番環境用の設定は含まれていません。これは開発環境専用の設定です

## ヘルプとサポート

問題が発生した場合は、以下を確認してください：

1. すべてのコンテナが正常に起動しているか
2. 環境変数が正しく設定されているか
3. 必要なポートが他のアプリケーションで使用されていないか
4. Node.jsとnpmが正しくインストールされているか

ログの確認方法や一般的な問題の解決方法については、上記のトラブルシューティングセクションを参照してください。
