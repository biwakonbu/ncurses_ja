(require :asdf)
(require :cl-charms)

(charms/ll:initscr)                                  ;; curses mode 開始
(charms/ll:raw)                                      ;; ラインバッファリング無効化
(charms/ll:keypad charms/ll:*stdscr* charms/ll:TRUE) ;; F1, F2 etc... の取得可能化
(charms/ll:noecho)                                   ;; (getch) でエコーしない

(charms/ll:printw (format nil "Type any character to see it in bold~%"))

                                                     ;; (raw) を事前に呼んで居ない場合、プログラムを実行する前に <enter> を押す必要があります
(let ((ch (charms/ll:getch)))                        ;; キーパッドを有効にしないとこれは私たちには届きません
                                                     ;; (noecho) がなければ醜いエスケープキャラクターがスクリーンに表示されている可能性があります
  (if (= ch (charms/ll:key_fn 1))
      (charms/ll:printw "F1 Key pressed")
      (progn
        (charms/ll:printw "The pressed key is ")
        (charms/ll:attron charms/ll:A_BOLD)
        (charms/ll:printw "%c" :char ch)
        (charms/ll:attroff charms/ll:A_BOLD))))

(charms/ll:refresh)                                  ;; 本当の (仮想ではない) スクリーン上に表示します
(charms/ll:getch)                                    ;; user の入力を待ちます
(charms/ll:endwin)                                   ;; curses mode の終了
