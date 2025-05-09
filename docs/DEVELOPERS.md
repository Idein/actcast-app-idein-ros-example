# 概要

本ドキュメントではActcast Appを開発するにあたって開発関連のTipsを書く

## 環境構築方法
1. Raspberry Pi 4bにActcastOS4をインストールする。
2. ローカルのパソコンにactdkをインストールする
3. actdk remote add bookworm@{Raspbrry PiのIPアドレス}
    - actcastのデバイスログから`172.`などで検索するとわかる
    - add後は`cat ~/.actdk/config.json`で変更を確認できる
4. actdk build bookworm
5. 開発する。以下のような形で好きに開発したら良い
    - `actdk debug container`でvscodeのremote development機能で開発し、コンテナ内の変更をダウンロードして開発する方法。`actdk stop`でコンテナは止めることができる。変更内容は恐らく`actdk stop`すると消えてしまうことに注意。
    - ローカルのコードを逐一修正し、`actdk run bookworm -a`で動かす方法。参考までに`actdk run`は処理がエラー終了するとRaspberry Piに再起動をかけてしまう。出力を確認するには、別途sshして`journalctl -f`でログを監視すると良い。

