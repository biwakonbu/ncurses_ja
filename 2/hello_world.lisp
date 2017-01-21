(require :asdf)
(require :cl-charms)

(charms/ll:initscr)
(charms/ll:printw "Hello World !!!")
(charms/ll:refresh)
(charms/ll:getch)
(charms/ll:endwin)
