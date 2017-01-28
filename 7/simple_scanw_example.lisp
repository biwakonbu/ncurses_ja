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
