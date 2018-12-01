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

(define arbitrary-integer-or-empty
    (arbitrary-mixed (list (cons '() arbitrary-integer)
                           (cons '() arbitrary-empty)
                           )))

(define arbitrary-boolean-or-empty
    (arbitrary-mixed (list (cons '() arbitrary-boolean)
                           (cons '() arbitrary-empty)
                           )))

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
        (equal?
          (unoperator-interpret (xsmap events (lambda (x) (add1 x))) null)
          (map (lambda (x) (add1 x)) events))
        )
      )))

(define (test-xsfold)
  (test-case "test-xsfold"
    (check-property
      (property ([tup-evts (arbitrary-tuple-events 1 arbitrary-integer-or-empty)])
        (define events (map first tup-evts))
        (define lst
          (binoperator-interpret (xsfold events + 0) null))
        (define sum
          (foldl (lambda (x acc) (if (empty? x) acc (+ x acc))) 0 events))
        (if (empty? events)
          (equal? lst empty)
          (equal? (first (reverse lst)) sum))
        )
      )))


(define/provide-test-suite lang2-tests
  (test-xsmap)
  (test-xsfold)
  )

(run-tests lang2-tests)
