(defpackage ticket-modelling-challenge/tests/main
  (:use :cl
        :ticket-modelling-challenge
        :rove))
(in-package :ticket-modelling-challenge/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :ticket-modelling-challenge)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
