#lang rosette

(require
  "lang.rkt" "hole.rkt"
  rackunit rackunit/text-ui
  racket/pretty
  )

(define (test-synth)
  (test-case "test-synth"
    (define inputsize 4)
    (define numinputs 2)
    (define spec
      (program
        numinputs
        (list
          (xsmapTo (r 0) 1)
          (xsmapTo (r 1) -1)
          (xsmerge (r 2) (r 3))
          (xsfold (r 4) + 0)
          )))

    (define sketch
      (program
        numinputs
        (build-list (length (program-instructions spec))
          (lambda (x) (??instruction)))
        ))

    (define sym-inputs
      (list
        (??stream (lambda () #t) numinputs)
        (??stream (lambda () #f) numinputs)))

    (printf "~%test-synth time:~%")
    (define M
      (time (synthesize
        #:forall (symbolics sym-inputs)
        #:guarantee (assert (equal?
          (program-interpret spec sym-inputs)
          (program-interpret sketch sym-inputs)
          )))))

    (check-true (sat? M))
    (printf "~%test-synth spec:~%")
    (pretty-print spec)
    (printf "~%test-synth solution:~%")
    (pretty-print (evaluate sketch M))
    ))


(define/provide-test-suite hole-tests
  (test-synth)
  )
(run-tests hole-tests)
