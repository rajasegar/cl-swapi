(defsystem "hello-caveman-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Rajasegar"
  :license ""
  :depends-on ("hello-caveman"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "hello-caveman"))))
  :description "Test system for hello-caveman"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
