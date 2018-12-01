#lang rosette

(require
  "lang.rkt"
  "hole.rkt")


(define spec
  (program
    2
    (list
      (xsmapTo (r 0) 1)
      (xsmapTo (r 1) -1)
      (xsmerge (r 2) (r 3))
      )))

(displayln "Spec evaluation:")
(program-interpret
  spec
  (list
    (list 'click empty 'click empty)
    (list empty 'click empty 'click)
    ))


(define inputs
  (??inputs (lambda (x) 'click) 4 2))

(define sketch
  (program
    (length inputs)
    (build-list (length inputs) (lambda (x) (??instruction)))
    ))

(define M
  (synthesize
    #:forall (symbolics inputs)
    #:guarantee (assert (equal?
      (program-interpret spec inputs)
      (program-interpret sketch inputs)
      ))))

(printf "~%Synthesized program:~%")
(evaluate sketch M)
