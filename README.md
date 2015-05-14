# auto-update.rb

## これは何?

複数のリモートサーバをまたいで WordPress をアップデートするための Ruby スクリプトです。設定ファイル（YAML 形式）に記述したリモートサーバに SSH でログインし、データベースをエクスポートした上で

* WordPress コアファイル
* プラグインファイル（[公式プラグインディレクトリ](https://wordpress.org/plugins/)にあるもの）
* テーマファイル（[公式テーマディレクトリ](https://wordpress.org/themes/)にあるもの）

を自動アップデートします。

## 動作要件

### ローカル側

* Ruby
* [Net::SSH ライブラリ](https://github.com/net-ssh/net-ssh)（ ``gem install net-ssh`` でインストール）

### リモート側

* [WP-CLI](http://wp-cli.org/)

レンタルサーバに WP-CLI を導入するシェルスクリプトも公開していますので、あわせてご参照ください。

[wp-cli.setup.sh](https://github.com/tecking/wp-cli.setup.sh) - WP-CLI をレンタルサーバに導入するためのシェルスクリプト

## 導入手順 

1. ``git clone`` または ZIP ファイルをダウンロードし展開
2. config-sample.yml を config.yml にリネーム
3. config.yml に設定を記述
4. ``ruby auto-update.rb`` で本スクリプトを実行

## config.yml の設定項目

必要でない項目がある場合はキー（例 key: ）のみを残し、値を空白にしてください。  
（記述例は config-sample.yml をご参照ください）

* name  
識別名（日本語も可）
* host  
リモートサーバのホスト名（IPアドレスも可）
* user  
SSH ログインユーザー名
* pass  
SSH ログインパスワード
* port  
SSH 接続時のポート
* key  
公開鍵認証を使う場合の秘密鍵ファイルへのパス
* phrase  
秘密鍵のパスフレーズ
* dir  
WordPress がインストールされているディレクトリ

## 留意事項

* At Your Own Risk にてお使いください
* リモート側のレンタルサーバは『さくらのレンタルサーバ』『ヘテムル』での動作を確認しています

## ライセンス

[MIT ライセンス](http://opensource.org/licenses/mit-license.php)で配布します。