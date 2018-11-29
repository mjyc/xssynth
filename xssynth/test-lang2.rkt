#lang racket

(require quickcheck rackunit/quickcheck "lang2.rkt" rackunit rackunit/text-ui)


(define arbitrary-integer-or-boolean
  (arbitrary-mixed (list (cons '() arbitrary-integer)
                         (cons '() arbitrary-boolean)
                         )))

(define (test-constant-interp)
  (test-case "test-constant-interp"
    (check-property
      (property ([int-or-bool arbitrary-integer-or-boolean])
        (eqv? (constant-interp (constant int-or-bool))
              int-or-bool)))
  ))
    ; (check-property
    ;   (property ([int-or-bool arbitrary-integer-or-boolean])
    ;     (eqv? (constant-interp (constant int-or-bool))
    ;           int-or-bool)))


(define/provide-test-suite lang2-tests
  (test-constant-interp)
  )

; (run-tests-quiet lang2-tests)

(run-tests lang2-tests)
