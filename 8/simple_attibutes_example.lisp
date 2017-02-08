(require :asdf)
(require :cl-charms)

(defvar prev nil)
(defvar row)
(defvar col)

(defvar x)
(defvar y)

(if (not (= (length *posix-argv*) 2))
    (progn
      (format t "Usage: ~a <a c file name>~%" (car *posix-argv*))
      (princ "Cannot open input file")
      #+sbcl(sb-ext:quit))) ;; for sbcl

(with-open-file (in (cadr *posix-argv*) :direction :input)
  (when in
    (charms/ll:initscr)
    (charms/ll:getmaxyx charms/ll:*stdscr* row col)
    (loop :for ch := (read-char in nil)
       :do (progn
             (charms/ll:getyx charms/ll:*stdscr* y x)
             (if (= y (1- row))
                 (progn
                   (charms/ll:printw "<-Press Any Key->")
                   (charms/ll:getch)
                   (charms/ll:clear)
                   (charms/ll:move 0 0)))
             (when prev
               (if (and (char= prev #\/)
                        (char= ch #\*))
                   (progn
                     (charms/ll:attron charms/ll:A_BOLD)
                     (charms/ll:getyx charms/ll:*stdscr* y x)
                     (charms/ll:move y (1- x))
                     (charms/ll:printw "%c%c" :char (char-code #\/) :char (char-code ch)))
                   (charms/ll:printw "%c" :char (char-code ch))))
             (charms/ll:refresh)
             (when prev
               (if (and (char= prev #\*)
                        (char= ch #\/))
                   (charms/ll:attron charms/ll:A_BOLD)))
             (setq prev ch)
             (charms/ll:endwin)))))
