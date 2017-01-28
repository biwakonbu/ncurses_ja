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
 :int col)
(charms/ll:printw "Try resizing your window (if possible) and then run this program again")
(charms/ll:refresh)
(charms/ll:getch)
(charms/ll:endwin)
