(require :asdf)
(require :cl-charms)

(defvar mesg (string "Just a string"))
(defvar row 0)
(defvar col 0)

(charms/ll:initscr)
(charms/ll:getmaxyx charms/ll:*STDSCR* row col)
(charms/ll:mvprintw
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
