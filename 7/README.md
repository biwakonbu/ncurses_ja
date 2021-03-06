# 7. 入力関数

さて、入力せずに出力するのは退屈です。  
ユーザーからの入力を可能にする関数を見てみましょう。これらの機能はまた、3つのカテゴリーに分けることができます。

1. (getch) クラス: 文字を取得する
2. (scanw) クラス: フォーマットに沿って入力を取得する
3. (getstr) クラス: 文字列を取得する

## 7.1. (getch) 関数のクラス

これらの関数は、端末から1文字を読み込みます。
しかし、考慮すべきいくつかの微妙な事実があります。たとえば、(cbreak) 関数を使用しない場合、curses は入力文字を連続的に読み取ることはありませんが、改行やEOFが発生した後にのみ読み込みを開始します。

これを避けるには、プログラムで文字をすぐに使用できるように (cbreak) 関数を使用する必要があります。

良く使われているもう1つの関数は (noecho) です。名前が示すように、この機能が設定 (使用) されると、ユーザーがキー入力した文字は画面に表示されません。
キー管理の典型的な例として、(cbreak) と (noecho) の2つの関数があります。このジャンルの機能は、[キー管理のセクション](11/RAEDME.md) で説明しています。

## 7.2. (scanw) 関数のクラス

これらの関数は scanf と似ていますが、画面上の任意の場所から入力を取得する機能が追加されています。

### 7.2.1. (scanw) and mvscanw

これらの関数の使用法は sscanf の場合と似ています。スキャンする行は (wgetstr) 関数によって提供されます。

### 7.2.2. (wscanw) and wmvscanw

これらは、上記の 2 つの関数と似ていますが、これらの関数の引数の 1 つとして提供されているウィンドウから読み込みます。

### 7.2.3. (vwscanw)

この関数は vscanf に似ています。これは、可変数の引数がスキャンされるときに使用できます。

## 7.3. (getstr) 関数のクラス

これらの関数は、端末から文字列を取得するために使用されます。  
要するに、この関数は、改行、キャリッジリターン、またはファイルの終わりが受信されるまで、一連の (getch) の呼び出しによって達成されるのと同じタスクを実行します。

結果として得られる文字列はユーザによって提供される文字ポインタである str によって指されます。

## 7.4. いくつかの例

### 例 4. 簡単な (scanw) の例

```lisp
(require :asdf)
(require :cl-charms)

(defvar mesg "Enter a string:")                 ;; 画面に表示されるメッセージ
(defparameter str (cffi:foreign-alloc :char))   ;; cffi:foreign-alloc で C の char 型にあわせる
(defvar row)                                    ;; 行
(defvar col)                                    ;; 列

(charms/ll:initscr)                             ;; curses モード開始
(charms/ll:getmaxyx charms/ll:*STDSCR* row col) ;; カーソルの行と列の取得
(charms/ll:mvprintw
 (ceiling (/ row 2))
 (ceiling (/ (- col (length mesg)) 2))
 "%s" :string mesg)                             ;; 画面の真ん中に表示

(charms/ll:getstr str)                          ;; 文字列の取得 (str は C の char 型にあわせる必要がある)
(charms/ll:mvprintw
 (- charms/ll:*LINES* 2)
 0
 (format nil "You Entered: %s~%")
 :string str)
(charms/ll:getch)
(charms/ll:endwin)
```
