(in-package :cl-user)
(defpackage hello-caveman.web
  (:use :cl
        :caveman2
        :hello-caveman.config
        :hello-caveman.view
        :hello-caveman.db
        :datafly
        :sxql
	:cl-json
	:drakma)
  (:export :*web*))
(in-package :hello-caveman.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;; Config drakma
(push (cons "application" "json") drakma:*text-content-types*)
(setf drakma:*header-stream* *standard-output*)


;;
;; Routing rules

(defroute "/" ()
(setq *results* (cl-json:decode-json-from-string
                   (drakma:http-request "https://swapi.dev/api/planets/"
                                        :method :get
                                        )))

  (format t "~a~%" (rest (assoc :results *results*)))
  (render #P"index.html" (list :planets (assoc :results *results*))))

(defroute "/about" ()
  (render #P"about.html"))

(defroute "/contact" ()
  (render #P"contact.html"))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
