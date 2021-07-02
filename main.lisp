(in-package #:cl-user)

;; (defvar *acceptor* nil)

(defun initialize-application (&key port)

  ;; (when *acceptor*
    ;; (hunchentoot:stop *acceptor*))
  (hello-caveman:start :port port))

  ;; (setf *acceptor*
	;; (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port port))))
