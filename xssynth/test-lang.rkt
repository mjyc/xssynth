#lang racket

(require
  rackunit rackunit/text-ui
  quickcheck rackunit/quickcheck
  "lang.rkt")


; Custom generators and arbitraries

(define arbitrary-integer-or-boolean
  (arbitrary-mixed (list (cons '() arbitrary-integer)
                         (cons '() arbitrary-boolean)
                         )))

(define generator-empty-event
  (generator (lambda (i rgen) empty)))

(define arbitrary-empty-event
  (arbitrary generator-empty-event
             (lambda (x gen) gen)
             ))

(define arbitrary-integer-or-boolean-or-empty-event
    (arbitrary-mixed (list (cons '() arbitrary-integer)
                           (cons '() arbitrary-boolean)
                           (cons '() arbitrary-empty-event)
                           )))

(define (arbitrary-tuple-events [tup-size 1]
                                [arb arbitrary-integer-or-boolean-or-empty-event])
  (arbitrary-list
    (apply arbitrary-tuple
      (build-list tup-size (lambda (x) arb)))))


; Tests

; (define (test-something)
;   (test-case "test-something"
;     (check-property
;       (property ([...


(define/provide-test-suite lang2-tests
  )

(run-tests lang2-tests)
