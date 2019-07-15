(defsystem "ticket-modelling-challenge"
  :version "0.1.0"
  :author "Windymelt"
  :license ""
  :depends-on (:local-time :dynamic-mixins)
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "ticket-modelling-challenge/tests"))))

(defsystem "ticket-modelling-challenge/tests"
  :author "Windymelt"
  :license ""
  :depends-on ("ticket-modelling-challenge"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for ticket-modelling-challenge"
  :perform (test-op (op c) (symbol-call :rove :run c)))
