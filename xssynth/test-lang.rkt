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

(define generator-empty
  (generator (lambda (i rgen) empty)))

(define arbitrary-empty
  (arbitrary generator-empty
             (lambda (x gen) gen)
             ))

(define arbitrary-integer-or-boolean-or-empty
    (arbitrary-mixed (list (cons '() arbitrary-integer)
                           (cons '() arbitrary-boolean)
                           (cons '() arbitrary-empty)
                           )))

(define (arbitrary-tuple-events [tup-size 1]
                                [arb arbitrary-integer-or-boolean-or-empty])
  (arbitrary-list
    (apply arbitrary-tuple
      (build-list tup-size (lambda (x) arb)))))


; Tests

(define (test-xsmap)
  (test-case "test-xsmap"
    (check-property
      (property ([tup-evts (arbitrary-tuple-events 1 arbitrary-integer)])
        (define events (map first tup-evts))

        ; (xsmap  (lambda x (+ x 1)))
        (displayln (r-interpret events null))
        #t
        )
      )))



(define/provide-test-suite lang2-tests
  (test-xsmap)
  )

(run-tests lang2-tests)
