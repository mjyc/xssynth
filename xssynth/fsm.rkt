#lang rosette

(require
  "lang.rkt"
  "hole.rkt"
  )


(define numinputs 1)

(define test-inputs
  (list
    (list 'c 'a 'a 'r)
    ))


(define (trans in s)
  (printf "in: ~a s: ~a~%" in s)
  (cond
    [(and (eqv? s 'init) (eqv? in 'c)) 'more]
    [(and (eqv? s 'more) (eqv? in 'a)) 'more]
    [(and (eqv? s 'more) (eqv? in 'd)) 'more]
    [(and (eqv? s 'more) (eqv? in 'r)) 'end]
    [else
      (printf "Undefined transition: s ~a in ~a~%" s in)
      s])
  )

(define prog
  (program
    numinputs
    (list
      (xsfold (r 0) trans 'init)
      )))


(displayln "Program evaluation:")
(program-interpret prog test-inputs)

