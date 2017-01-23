(require :asdf)
(require :cl-charms)

(charms/ll:initscr)
(charms/ll:raw)
(charms/ll:keypad charms/ll:*stdscr* charms/ll:TRUE)
(charms/ll:noecho)

(charms/ll:printw (format nil "Type any character to see it in bold~%"))
(let ((ch (charms/ll:getch)))
  (if (= ch (charms/ll:key_fn 1))
      (charms/ll:printw "F1 Key pressed")
      (progn
        (charms/ll:printw "The pressed key is ")
        (charms/ll:attron charms/ll:A_BOLD)
        (charms/ll:printw "%c" :char ch)
        (charms/ll:attroff charms/ll:A_BOLD))))

(charms/ll:refresh)
(charms/ll:getch)
(charms/ll:endwin)
