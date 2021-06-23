(ql:quickload :hello-caveman)
(require :asdf)
(defvar *port* (parse-integer (asdf::getenv "PORT")))
(hello-caveman:start :port *port*)
