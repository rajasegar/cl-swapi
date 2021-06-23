(in-package :cl-user)
(defpackage hello-caveman.web
  (:use :cl
        :caveman2
        :hello-caveman.config
        :hello-caveman.view
        :hello-caveman.db
	:cl-json
	:drakma
	:cl-who)

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
  (render #P"index.html" ))

;; Planets index route
(defroute "/planets" ()
  (setq *planets* (cl-json:decode-json-from-string
		   (drakma:http-request "https://swapi.dev/api/planets/"
					:method :get
					)))
  ;; (format t "~a~%" (rest (assoc :results *planets*)))
  (render #P"planets.html" (list :planets (rest (assoc :results *planets*))
				 :active-page "planets"
				 )))

;; Planets show route
(defroute "/planets/:id" (&key id)
  (setq *planet* (cl-json:decode-json-from-string
		   (drakma:http-request (concatenate 'string "https://swapi.dev/api/planets/" id)
					:method :get
					)))
  ;; (format t "~a%" *planet*)
  (render #P"planets.html" (list :planets (rest (assoc :results *planets*))
				 :planet *planet*
				 :active-page "planets"
				 )))


;; People index route
(defroute "/people" ()
  (setq *people* (cl-json:decode-json-from-string
		   (drakma:http-request "https://swapi.dev/api/people/"
					:method :get
					)))
  (render #P"people.html" (list :people (rest (assoc :results *people*))
				:active-page "people"
				)))

;; People search route
(defroute ("/people/search" :method :POST) (&key _parsed)
  ;; (format t "~a~%"  (cdr (assoc "search" _parsed :test #'string=)))
  (setq query  (cdr (assoc "search" _parsed :test #'string=)))
  (setq *search-results* (cl-json:decode-json-from-string
		   (drakma:http-request (concatenate 'string "https://swapi.dev/api/people/?search=" query)
					:method :get
					)))
  (format t "~a~%" *search-results*)
  (with-html-output-to-string (output nil :prologue nil)
    (loop for p in (rest (assoc :results *search-results*))
	  do (htm (:li
		   (:a :href "/people/" (str (cdr (assoc :name p)))))))))

;; People show route
(defroute "/people/:id" (&key id)
  (setq *character* (cl-json:decode-json-from-string
		   (drakma:http-request (concatenate 'string "https://swapi.dev/api/people/" id)
					:method :get
					)))
  ;; (format t "~a~%" *character*)
  (render #P"people.html" (list :people (rest (assoc :results *people*))
				:character *character*
				:active-page "people"
				)))



;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
