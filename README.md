# ev3rt-build
===============

# はじめに
dockerにてEV3RT(arm用ビルド環境)ビルド環境を提供するコンテナです。  
sshdを内包しており、コンテナ起動時に設定した1ユーザでログインできます。  
コンテナはportがぶつからない限り、任意の数起動できます。  
jenkins-slaveとしての利用を想定し、javaとsshdをインストール済みです。

また、コンテナ内のファイルはホスト側からは隔離されます。永続的なファイルの保存が必要な場合は-vオプションを使用してホスト側のディレクトリをマウントしてください。

使い方
------
# Installation
以下のようにdocker imageをpullします。

    docker pull sharaku/ev3rt-build

Docker imageを自分で構築することもできます。

    https://github.com/sharaku/docker-ev3rt-build.git
    cd docker-ev3rt-build
    docker build --tag="$USER/ev3rt-build" .

# Quick Start
ev3rt-buildのimageを実行します。

    docker run -d -e "LOGIN_USER=login_user:login_user_passwd" -p 10022:22 sharaku/ev3rt-build

sshdの代わりに/bin/bashで起動することもできます。
この場合、rootユーザでのログインとなります。

    docker run -it sharaku/ev3rt-build /bin/bash

## Argument

+   `-v /path/to/data:/path/to/container/data:rw` :  
    永続的に保存するデータのディレクトリを指定します。任意の数の-vオプションを使用可能です。

+   `-e "LOGIN_USER=login_user:login_user_passwd"` :  
    ログインするユーザ名、パスワードを":"で区切って指定します。  
    例：-e "LOGIN_USER=hogehoge:hogehoge-passwd"

+   -p port:22 :  
    外部公開するポートを設定します。

# Installed environment
ev3rt-buildコンテナには以下がインストール済みです。

base:debian 7.6

servers:

    sshd

build tools:

    build-essential, cppcheck
    gcc-arm-none-eabi=4.9.3.2015q1-0trusty13, u-boot-tools, libboost1.55-all-dev

tools:

    wget, git, vim, bzip2, nkf, unzip, bc, default-jdk, qemu

利用例
------

# ev3rt-build
スタンダードなev3rt-buildとして使用するには以下のようにします。

以下の条件でev3rt-buildを構築する例です。

+ docker動作ホストのIP：192.168.0.2
+ ユーザ名：hogehoge
+ パスワード：hogehoge-passwd
+ ポート：10022
+ ボリューム（ホスト側）：/var/lib/build-volume
+ ボリューム（コンテナ側）：/var/lib/volume

　

    mkdir /var/lib/build-volume

    docker run -d \
      -v /var/lib/build-volume:/var/lib/volume:rw \
      -e "LOGIN_USER=hogehoge:hogehoge-passwd" \
      -p 10022:22 sharaku/ev3rt-build


# jenkins-slave
jenkins-slaveとして使用するには以下のようにします。

+ ユーザ名：jenkins
+ パスワード：jenkins###
+ jenkinsポート：8080
+ ポート(内部利用)：10022
+ ボリューム（ホスト側）：/var/lib/jenkins-volume
+ ボリューム（コンテナ側）：/var/lib/jenkins

手順

1.ビルド環境の保存領域を作成します  

      mkdir /var/lib/jenkins-volume

2.sharaku/ev3rt-buildコンテナを起動します。  

      docker run -d \
        -v /var/lib/jenkins-volume:/var/lib/jenkins:rw \
        -e "LOGIN_USER=jenkins:jenkins###" \
        -p 10022:22 sharaku/ev3rt-build

3.jenkinsを起動し、設定を行います。  

      docker run -d -p 8080:8080 jenkins

4.ブラウザから、jenkinsへ接続します。  
5.jenkinsのメニューから `Jenkinsの管理 -> ノードの管理 -> 新規ノード作成` を開きます。  
6. `ノード名` を入力後、`ダムスレーブ` にチェックを入れ、`OK`を押します。  
7.`リモートFSルート`は"/var/lib/jenkins"を入力します。  
8.`起動方法`は"ssh経由で～"を選択します。  
9.`ホスト`はホストのIPもしくは、ドメインを指定します。  
10.`認証情報`は`add`を押し、ユーザ名とパスワードを設定します。  
11.`高度な設定`を押し、`ポート`の欄に10022を指定します。  
12.`保存`を押します。

以上で接続ができるようになります。
