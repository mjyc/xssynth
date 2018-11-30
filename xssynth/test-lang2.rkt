#lang racket

(require quickcheck rackunit/quickcheck "lang2.rkt" rackunit rackunit/text-ui)


; Custom generators and arbitraries

(define arbitrary-integer-or-boolean
  (arbitrary-mixed (list (cons '() arbitrary-integer)
                         (cons '() arbitrary-boolean)
                         )))

(define generator-empty-event
  (generator (lambda (i rgen) (empty-event))))

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

(define (test-constant-interpret)
  (test-case "test-constant-interpret"
    (check-property
      (property ([int-or-bool arbitrary-integer-or-boolean])
        (define c (constant int-or-bool))
        (eqv? (constant-interpret c)
              int-or-bool)))
  ))

(define (test-$-interpret)
  (test-case "test-$-interpret"
    (check-property
      (property ([events (arbitrary-tuple-events)])
        (define s (stream events))
        (equal? ($-interpret s) s)))
  ))


(define/provide-test-suite lang2-tests
  (test-constant-interpret)
  (test-$-interpret)
  )

(run-tests lang2-tests)
