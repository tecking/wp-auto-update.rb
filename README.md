# wp-auto-update.rb

## これは何?

複数のリモートサーバをまたいで WordPress をアップデートする Ruby スクリプトです。設定ファイル（YAML 形式）に記述したリモートサーバに SSH でログインし、データベースをエクスポートした上で

* WordPress コア
* プラグイン（[公式プラグインディレクトリ](https://wordpress.org/plugins/)にあるもの）
* テーマ（[公式テーマディレクトリ](https://wordpress.org/themes/)にあるもの）

を自動アップデートします。

## 動作要件

### ローカル側

* Ruby
* [Net::SSH ライブラリ](https://github.com/net-ssh/net-ssh)（ ``gem install net-ssh`` でインストール）
* Mail ライブラリ（ ``gem install mail`` でインストール）

### リモート側

* SSH 接続でき（公開鍵認証も可）、[WP-CLI](http://wp-cli.org/) が動作するサーバ

レンタルサーバに WP-CLI を導入するシェルスクリプトも公開していますので、あわせてご参照ください。

[wp-cli.setup.sh](https://github.com/tecking/wp-cli.setup.sh) - WP-CLI をレンタルサーバに導入するためのシェルスクリプト

## 導入手順 

1. ``git clone`` または ZIP ファイルをダウンロードし展開
2. config-sample.yml を config.yml （設定ファイル）にリネーム
3. config.yml に設定を記述
4. ``ruby wp-auto-update.rb`` で本スクリプトを実行

## config.yml の設定項目
 
記述例は config-sample.yml をご参照ください。(*)は必須項目です。

* from (*)  
実行結果メールの送信元 E-mail アドレス
* to (*)  
実行結果メールのあて先 E-mail アドレス
* subject  
実行結果メールの題名（ISO 8601 形式の日付文字列フォーマットが使えます）
* name (*)  
識別名（日本語も可）
* url (*)  
サイトURL
* host (*)  
リモートサーバのホスト名（FQDN　IPアドレスも可）
* user (*)  
SSH ログインユーザー名
* pass  
SSH ログインパスワード（公開鍵認証を使う場合は省略可）
* port (*)  
SSH 接続時のポート
* key  
公開鍵認証を使う場合の秘密鍵ファイルへのパス
* phrase  
秘密鍵のパスフレーズ
* dir (*)  
WordPress がインストールされているディレクトリ

## 実行時のオプション 

-f オプションで実行時の設定ファイルを指定できます。指定のないときは、同階層にある config.yml を設定ファイルとして読み込みます。

### 例

``ruby wp-auto-update.rb -f config.foobar.yml``

## 留意事項

* At Your Own Risk にてお使いください
* リモート側のレンタルサーバは『さくらのレンタルサーバ』『ヘテムル』での動作を確認しています

## 変更履歴

* 0.2.0（ 2015-05-19 ）
 * 実行結果のメール送信機能追加
 * アップデート処理終了時のサイト死活チェック機能追加
* 0.1.0（ 2015-05-15 ）
 * 公開

## ライセンス

[MIT ライセンス](http://opensource.org/licenses/mit-license.php)で配布します。