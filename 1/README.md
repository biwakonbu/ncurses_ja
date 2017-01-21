# 1.はじめに
昔ながらのテレタイプ端末では、端末はコンピュータから離れており、シリアルケーブルを介して端末に接続されていました。  
端末は、一連の文字を送信することによって構成することができます。  
ターミナルのすべての機能（カーソルを新しい場所に移動する、画面の一部を消す、画面をスクロールする、モードを変更するなど）は、これら一連のバイトを通じてアクセスできます。  
これらの制御記号は、エスケープ（0x1B）文字で始まるため、通常はエスケープシーケンスと呼ばれます。  
今日でもエミュレーションをエミュレートすることでエスケープシーケンスをエミュレータに送信し、ターミナルウィンドウでも同様の効果を得ることができます。

色を使って線を表示したいとします。あなたのコンソールにこれを入力してみてください。

```bash
echo "^[[0;31;40mIn Color"
```

最初の文字はエスケープ文字で、^と[]の2文字のように見えます。  
それを印刷するには、CTRL + Vを押してからESCキーを押す必要があります。他はすべて通常の印刷可能文字です。  
文字列「In Color」は赤で表示されるはずです。  
そのままの状態で元のモードに戻ります。

```bash
echo "^[[0;37;40m"
```

今、これらの魔法の文字はどういう意味ですか？ 理解が難しいですか？  
それらは、端末毎に異なっている場合があります。  
そこで、UNIX の設計者は termcap という仕組みを発明しました。  
これは、特定の効果を達成するために必要なエスケープシーケンスと一緒に、特定の端末のすべての機能をリストするファイルです。  
後の年に、これは terminfo に置き換えられました。  
このメカニズムにより、詳細を掘り下げることなく、アプリケーション・プログラムは terminfo データベースに照会し、端末または端末エミュレーターに送信する制御文字を取得できます。

## 1.1. NCURSES とは?

あなたは、この技術的不器用さのすべてのインポートが何であるか疑問に思うかもしれません。  
上記のシナリオでは、すべてのアプリケーションプログラムが terminfo を照会し、必要なものを実行する（制御文字を送信するなど）と想定されています。  
すぐにこの複雑さを管理することが困難になり、これが 'CURSES' を生み出しました。Curses は、"カーソル最適化" からもじった名前です。  
Curses ライブラリは、生のターミナルコードを扱うためのラッパーを形成し、非常に柔軟で効率的な API（Application Programming Interface）を提供します。  
カーソルの移動、ウィンドウの作成、色の生成、マウスでの再生などの機能を提供します。アプリケーションプログラムは、基礎となる端末機能を心配する必要はありません。
 
NCURSES とは何でしょうか？ NCURSES は、元の System V Release 4.0（SVr4）の curses のクローンです。  
古いバージョンの curses と完全に互換性のある、自由に配布可能なライブラリです。  
要するに、文字セル端末上のアプリケーションの表示を管理する関数のライブラリです。この文書の残りの部分では、curses と ncurses という言葉は同じ意味で使われています。

## 1.2. NCURSES でできること

NCURSES は、端末機能に対するラッパーを作成するだけでなく、見栄えのよい UI（ユーザーインターフェース）をテキストモードで作成するための堅牢なフレームワークを提供します。ウィンドウなどを作成する関数を提供します。  
その姉妹ライブラリのパネル、メニュー、フォームは、基本的な curses ライブラリの拡張機能を提供します。  
これらのライブラリは通常、curses と一緒に来ます。複数のウィンドウ、メニュー、パネル、フォームを含むアプリケーションを作成できます。  
Windows は独立して管理することができ、'スクロール可能性' を提供することができ、さらには非表示にすることもできます。

メニューは、ユーザーに簡単なコマンド選択オプションを提供します。フォームを使用すると、使いやすいデータ入力ウィンドウと表示ウィンドウを作成できます。パネルは ncurses の機能を拡張して、重ねて積み重ねたウィンドウに対応します。

パッケージのコンパイル

(ftp://ftp.gnu.org/pub/gnu/ncurses/ncurses.tar.gz) または (http://www.gnu.org/order/ftp.html) に記載されている ftp サイトから入手できます。

```
    tar zxvf ncurses<version>.tar.gz  # アーカイブの伸張と展開
    cd ncurses<version>               # ncurses ディレクトリに移動
    ./configure                       # 環境に合わせてビルドを設定する
    make                              # ビルド
    su root                           # root になる
    make install                      # インストール
```

RPM を使う

NCURSES RPM は (http://rpmfind.net) からダウンロードできます。RPM は root になった後、次のコマンドでインストールすることができます。

```
    rpm -i <downloaded rpm>
```

## 1.4. 文書の目的/範囲

このドキュメントは、ncurses とその姉妹ライブラリを使ったプログラミングのための「オールインワン」ガイドであることを意図しています。  
私たちは単純な "Hello World" プログラムを卒業し、より複雑なフォーム操作が出来るようになります。  
ncurses 以前の経験は想定されていません。執筆は非公式ですが、それぞれの例について多くの詳細が提供されています。

## 1.5. プログラムについて

ドキュメントのすべてのプログラムは、[ここ](http://www.tldp.org/HOWTO/NCURSES-Programming-HOWTO/ncurses_programs.tar.gz)から圧縮された物が入手できます。伸張、展開します。ディレクトリ構造は次のようになります。

```
ncurses
   |
   |----> JustForFun     -- just for fun programs
   |----> basics         -- basic programs
   |----> demo           -- output files go into this directory after make
   |          |
   |          |----> exe -- exe files of all example programs
   |----> forms          -- programs related to form library
   |----> menus          -- programs related to menus library
   |----> panels         -- programs related to panels library
   |----> perl           -- perl equivalents of the examples (contributed
   |                            by Anuradha Ratnaweera)
   |----> Makefile       -- the top level Makefile
   |----> README         -- the top level README file. contains instructions
   |----> COPYING        -- copyright notice
```

個々のディレクトリには、次のファイルが含まれています。

```
Description of files in each directory
--------------------------------------
JustForFun
    |
    |----> hanoi.c   -- The Towers of Hanoi Solver
    |----> life.c    -- The Game of Life demo
    |----> magic.c   -- An Odd Order Magic Square builder 
    |----> queens.c  -- The famous N-Queens Solver
    |----> shuffle.c -- A fun game, if you have time to kill
    |----> tt.c      -- A very trivial typing tutor

  basics
    |
    |----> acs_vars.c            -- ACS_ variables example
    |----> hello_world.c         -- Simple "Hello World" Program
    |----> init_func_example.c   -- Initialization functions example
    |----> key_code.c            -- Shows the scan code of the key pressed
    |----> mouse_menu.c          -- A menu accessible by mouse
    |----> other_border.c        -- Shows usage of other border functions apa
    |                               -- rt from box()
    |----> printw_example.c      -- A very simple printw() example
    |----> scanw_example.c       -- A very simple getstr() example
    |----> simple_attr.c         -- A program that can print a c file with 
    |                               -- comments in attribute
    |----> simple_color.c        -- A simple example demonstrating colors
    |----> simple_key.c          -- A menu accessible with keyboard UP, DOWN 
    |                               -- arrows
    |----> temp_leave.c          -- Demonstrates temporarily leaving curses mode
    |----> win_border.c          -- Shows Creation of windows and borders
    |----> with_chgat.c          -- chgat() usage example

  forms 
    |
    |----> form_attrib.c     -- Usage of field attributes
    |----> form_options.c    -- Usage of field options
    |----> form_simple.c     -- A simple form example
    |----> form_win.c        -- Demo of windows associated with forms

  menus 
    |
    |----> menu_attrib.c     -- Usage of menu attributes
    |----> menu_item_data.c  -- Usage of item_name() etc.. functions
    |----> menu_multi_column.c    -- Creates multi columnar menus
    |----> menu_scroll.c     -- Demonstrates scrolling capability of menus
    |----> menu_simple.c     -- A simple menu accessed by arrow keys
    |----> menu_toggle.c     -- Creates multi valued menus and explains
    |                           -- REQ_TOGGLE_ITEM
    |----> menu_userptr.c    -- Usage of user pointer
    |----> menu_win.c        -- Demo of windows associated with menus

  panels 
    |
    |----> panel_browse.c    -- Panel browsing through tab. Usage of user 
    |                           -- pointer
    |----> panel_hide.c      -- Hiding and Un hiding of panels
    |----> panel_resize.c    -- Moving and resizing of panels
    |----> panel_simple.c    -- A simple panel example

  perl
    |----> 01-10.pl          -- Perl equivalents of first ten example programs
```

メインディレクトリにはトップレベルの Makefile が含まれています。  
すべてのファイルをビルドし、すぐに使える exes を demo/exe ディレクトリに置きます。  
対応するディレクトリに移動することで、選択的な make を行うこともできます。  
各ディレクトリには、ディレクトリ内の各 c ファイルの目的を説明する README ファイルが含まれています。

どの例でも、examples ディレクトリを基準にしたファイルのパス名が含まれています。

個々のプログラムを閲覧したい場合は、ブラウザで (http://tldp.org/HOWTO/NCURSES-Programming-HOWTO/ncurses_programs/) にアクセスしてください。

すべてのプログラムは、ncurses（MIT 形式）で使用されるのと同じライセンスでリリースされています。  
これはあなたにあなたのものと主張する以外の何かをする能力を与えます。  
必要に応じてプログラムで自由に使用してください。

## 1.6. 文書のその他の形式

このハウツーは、tldp.org サイトのさまざまな他のフォーマットでも利用できます。  
このドキュメントの他のフォーマットへのリンクがあります。

### 1.6.1. tldp.orgから簡単に入手できるフォーマット

- [Acrobat PDF Format](http://www.ibiblio.org/pub/Linux/docs/HOWTO/other-formats/pdf/NCURSES-Programming-HOWTO.pdf)
- [PostScript Format](http://www.ibiblio.org/pub/Linux/docs/HOWTO/other-formats/ps/NCURSES-Programming-HOWTO.ps.gz)
- [In Multiple HTML pages](http://www.ibiblio.org/pub/Linux/docs/HOWTO/other-formats/html/NCURSES-Programming-HOWTO-html.tar.gz)
- [In One big HTML format](http://www.ibiblio.org/pub/Linux/docs/HOWTO/other-formats/html_single/NCURSES-Programming-HOWTO.html)

### 1.6.2. ソースのビルド

上記のリンクが壊れている場合や、sgmlの読み込みを試したい場合。

```
    Get both the source and the tar,gzipped programs, available at
        http://cvsview.tldp.org/index.cgi/LDP/howto/docbook/
        NCURSES-HOWTO/NCURSES-Programming-HOWTO.sgml
        http://cvsview.tldp.org/index.cgi/LDP/howto/docbook/
        NCURSES-HOWTO/ncurses_programs.tar.gz

    Unzip ncurses_programs.tar.gz with
    tar zxvf ncurses_programs.tar.gz

    Use jade to create various formats. For example if you just want to create
    the multiple html files, you would use
        jade -t sgml -i html -d <path to docbook html stylesheet>
        NCURSES-Programming-HOWTO.sgml
    to get pdf, first create a single html file of the HOWTO with 
        jade -t sgml -i html -d <path to docbook html stylesheet> -V nochunks
        NCURSES-Programming-HOWTO.sgml > NCURSES-ONE-BIG-FILE.html
    then use htmldoc to get pdf file with
        htmldoc --size universal -t pdf --firstpage p1 -f <output file name.pdf>
        NCURSES-ONE-BIG-FILE.html
    for ps, you would use
        htmldoc --size universal -t ps --firstpage p1 -f <output file name.ps>
        NCURSES-ONE-BIG-FILE.html
```

詳細については [LDP の作成者ガイド](http://www.tldp.org/LDP/LDP-Author-Guide/) を参照してください。  
それ以外の場合は、ppadalaあっとgmail.com までメールしてください。

## 1.7. クレジット

少数のセクションで私を助けてくれた Sharath と Emre Akbas に感謝します。  
はじめは sharath によって書かれました。私は彼の初期の作品から抜粋したものをほとんど書き直していません。  
Emre は printw と scanw セクションを書くのを助けてくれました。

サンプルプログラムの Perl に相当するものは、Anuradha Ratnaweera によって提供されています。

## 1.8. ウィッシュリスト

これは優先順位の高い順に希望リストです。希望がある場合、または希望を完了するために作業したい場合は、私にメールしてください。

- フォームセクションの最後の部分に例を追加します。
- すべてのプログラムを示すデモを準備し、ユーザーが各プログラムの説明を閲覧できるようにします。ユーザーが実際にプログラムをコンパイルして見てみましょう。ダイアログベースのインターフェースが好ましい。
- デバッグ情報を追加します。_tracef, _tracemouseもの。
- termcap、terminfo にアクセスするには、ncurses パッケージが提供する関数を使用します。
- 同時に2つの端末で作業する。
- 雑多なセクションに多くのものを追加してください。

## 1.9. Copyright

本ソフトウェアおよび関連するドキュメンテーションファイル（以下「本ソフトウェア」といいます）のコピーを取得した者は、本ソフトウェアを制限なく使用、複製、変更、マージする権利を含むがこれに限定されない ソフトウェアの複製、出版、配布、頒布、再サブライセンス、および/または販売を行うこと、および次の条件のもとで本ソフトウェアの提供を受ける者に許可すること。

上記の著作権表示およびこの許可通知は、本ソフトウェアのすべてのコピーまたは実質的な部分に含まれるものとします。

本ソフトウェアは、商品性、特定の目的への適合性および非侵害性の保証を含むが、明示的または黙示的ないかなる保証もなく、現状のまま提供されます。  

いかなる場合においても、上記の著作権者は、本ソフトウェアに関連して、または本ソフトウェアの使用またはその他の取引において、契約違反、その他の違法行為に関わらず、いかなる請求、損害またはその他の責任についても責任を負うものではありません。

この通知に記載されている場合を除き、上記の著作権者の名前は、事前の書面による許可なく、本ソフトウェアの販売、使用その他の取引を宣伝するために使用するものではありません。

[Next](../2/README.md)
