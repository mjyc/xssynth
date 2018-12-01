#lang rosette

(require
  "lang.rkt"
  "hole.rkt")

(define inputsize 4)
(define numinputs 2)



(define spec
  (program
    numinputs
    (list
      (xsmapTo (r 0) 1)
      (xsmapTo (r 1) -1)
      (xsmerge (r 2) (r 3))
      ; (xsfold (r 4) + 0)
      ; (xsmapTo (r 0) 1)
      ; (xsfold (r 2) + 0)
      )))

(define test-inputs
  (list
    (list #t empty #t empty)
    (list empty #f empty #f)
    ))

(displayln "Spec evaluation:")
(program-interpret spec test-inputs)



(define sketch
  (program
    numinputs
    (build-list (length (program-instructions spec))
      (lambda (x) (??instruction)))
    ))

(define M
  (solve
    (assert
      (equal?
        (program-interpret spec test-inputs)
        (program-interpret sketch test-inputs)
        )))
  )
(printf "~%Angelic execution:~%")
(if (sat? M)
  (evaluate sketch M)
  (displayln "No program found"))



(define sym-inputs
  (??inputs (lambda (x) #t) inputsize numinputs))

(define M2
  (synthesize
    #:forall (symbolics sym-inputs)
    #:guarantee (assert (equal?
      (program-interpret spec sym-inputs)
      (program-interpret sketch sym-inputs)
      ))))

(printf "~%Program synthesis:~%")
(if (sat? M2)
  (evaluate sketch M2)
  (displayln "No program found"))
