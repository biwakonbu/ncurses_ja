# 2. Hello World !!!

curses の世界へようこそ。ライブラリに入り込み、そのさまざまな機能を調べる前に、簡単なプログラムを書いて、世界にこんにちはと言いましょう。

## 2.1. NCURSES ライブラリを使用してコンパイルする

ncurses ライブラリ関数を使用する為に、プログラムに cl-charms をインストールする必要があります。  
下記コマンドでインストールする事が出来ます。

```
    sbcl
    * (ql:quickload :cl-charms)
```

cl-charms インストール時の注意点として、SBCL, ASDF の二つのバージョンが低い場合、こける事があります。  
SBCL v1.3.13, ASDF v3.1.5 では動作確認済です。

### 例 1. Hello World !!! プログラム

quicklisp でのインストールが出来ていて、asdf もセットアップ済の場合、asdf を require する事で cl-charms も require 可能になります。

```lisp
;; hello_world.lisp

(require :asdf)
(require :cl-charms)

(charms/ll:initscr)
(charms/ll:printw "Hello World !!!")
(charms/ll:refresh)
(charms/ll:getch)
(charms/ll:endwin)
```

実行は下記の通りにコンソールから行ないます。

```
    sbcl --script hello_world.lisp
```

