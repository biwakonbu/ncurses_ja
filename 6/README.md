# 出力関数

そろそろ何か書きたくなってきたのではないでしょうか。  
curses 関数の旅に戻ります。curses が初期化されたので、世界とやり取りしましょう。

画面に出力するために使用できる 3 つのクラスの関数があります。

1. (addch) クラス: 属性付きの 1 文字を出力する
2. (printw) クラス: C 言語の printf と同様の書式付き出力を出力する
3. (addstr) クラス: 文字列の出力

## 6.1. (addch) クラスの関数

これらの関数は現在のカーソル位置に1文字を置き、カーソルの位置を前進させます。  
文字を出力するように指定することはできますが、通常はいくつかの属性を持つ文字を出力するために使用されます。  
属性については、このドキュメントの後の [セクション](8/README.md) で詳しく説明します。  
文字が属性 (太字、反転表示など) に関連付けられている場合、curses がその文字を出力すると、それがその属性に出力されます。

文字と属性を組み合わせるには、次の2つの方法があります。

- 単一の文字を目的の属性マクロと OR 演算します。これらの属性マクロは、ヘッダファイル ncurses.h にあります。  
  たとえば、文字 ch (太字の) を太字と下線で出力する場合は、以下のように (addch) を呼び出します。
  `(charms/ll:addch (logior ch charms/ll:A_BOLD charms/ll:A_UNDERLINE))`
- (attrset)、(attron)、(attroff) などの関数を使用します。これらの関数については、[属性](8/README.md) セクションで説明します。簡単に言えば、指定されたウィンドウの現在の属性を操作します。
  一旦設定されると、ウィンドウに出力された文字はオフになるまで属性に関連付けられます。

さらに curses は文字ベースのグラフィックにいくつかの特殊文字を提供します。テーブル、水平または垂直線などを描くことができます。  
使用可能なすべての文字は、ヘッダファイル ncurses.h にあります。このファイルで ACS_ で始まるマクロを探してみてください。

## 6.2. (mvaddch), (waddch) と (mvwaddch)

(mvaddch) はカーソルを指定されたポイントに移動してから出力するために使用されます。その為、このように書いた物を

```lisp
(move row col)
(addch ch)
```

このように置き換える事ができます。

```lisp
(mvaddch row col ch)
```

(waddch) は (addch) と似ていますが指定されたウィンドウに文字を追加する点が異なります。((addch) は文字をウィンドウ stdscr に挿入します)。

同様に (mvwaddch) 関数は与えられた座標、与えられたウィンドウに文字を追加するために使われます。

ここでは基本出力関数 (addch) に精通しています。しかし、文字列を出力したい場合、文字単位で出力するのは非常に面倒です。  
幸いにも、ncurses は printf のような機能や puts のような機能を提供します。

## 6.3. (printw) 関数のクラス

これらの関数は (printf) と似ていて、画面上の任意の位置に出力する機能が追加されています。

### 6.3.1. (printw) と mvprintw

これらの 2 つの関数は printf とよく似ています。(mvprintw) はカーソルをある位置に移動してから出力するために使用できます。  
最初にカーソルを移動して (printw) 関数を使用したい場合は (move) を先に使用して (printw) を使用してください。  
(mvprintw) を使用するよりも柔軟に操作する事が出来ます。

### 6.3.2. (wprintw) と mvwprintw

これらの 2 つの関数は引数として与えられた、対応するウィンドウに出力する点を除いて、上記 2 つに似ています。

### 6.3.3. (vwprintw)

この関数は vprintf に似ています。可変長の引数を出力する場合に使用できます。

### 6.3.4. 簡単な printw の例

#### 例 3. 簡単な printw の例

```lisp
(require :asdf)
(require :cl-charms)                            ;; ncurses ライブラリ

(defvar mesg (string "Just a string"))          ;; スクリーンに表示するメッセージ
(defvar row 0)                                  ;; スクリーンに表示する行の保存
(defvar col 0)                                  ;; スクリーンに表示する列の保存

(charms/ll:initscr)                             ;; curses モード開始
(charms/ll:getmaxyx charms/ll:*STDSCR* row col) ;; 行番号と列番号を取得
(charms/ll:mvprintw                             ;; スクリーンの真ん中に出力
 (ceiling (/ row 2))
 (ceiling (/ (- col (length mesg)) 2))
 "%s" :string mesg)

(charms/ll:mvprintw
 (- row 2)
 0
 (format nil "This screen has %d rows and %d columns~%")
 :int row
 :int col
 :string mesg)
(charms/ll:printw "Try resizing your window (if possible) and then run this program again")
(charms/ll:refresh)
(charms/ll:getch)
(charms/ll:endwin)
```

上記のプログラムは printw の使い方を簡単に示しています。  
画面上に表示される座標とメッセージを入力するだけで、あなたが望むことができます。

上記のプログラムでは ncurses で定義されているマクロ (getmaxyx) を紹介します。  
(getmaxyx) は与えられたウィンドウ内の列の数と行の数を与えます。(getmaxyx) は与えられた変数を更新して行と列を取得します。

(getmaxyx) は 2 つの整数変数を与えるだけで座標を更新できます。

## 6.4. (addstr) 関数のクラス

(addstr) は指定されたウィンドウに文字列を挿入するために使用されます。  
この関数は与えられた文字の各文字に対して (addch) を1回呼び出すことに似ています。  
これはすべての出力関数に当てはまります。curses の命名規則に従う (mvaddstr)、(mvwaddstr)、(waddstr) などの他の関数もあります。

(例えば (mvaddstr) はそれぞれの (move) と (addstr) の呼び出しと同様です。) このファミリのもう一つの関数は (addnstr) です。  
この関数は最大 n 文字を画面に表示します。n が負の場合文字列全体が追加されます。

## 6.5. 慎重な言葉

これらのすべての関数はまず y 座標をとり、引数の x をとります。  
初心者のよくある間違いは、x、y の順番で渡すことです。  
(y、x) 座標の操作が多すぎる場合は画面をウィンドウに分割し、それぞれを個別に操作することを検討してください。  
[Windows](9/README.md) は Windows セクションで説明されています。
