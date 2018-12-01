#lang rosette

(require
  "lang.rkt"
  "hole.rkt")


(binoperator-interpret (xsfold (r 0) + 0) (vector (list 1 2)))

(define M
  (solve
    (assert
      (equal?
        (instruction-interpret (xsfold (r 0) + 0) (vector (list 1 2)))
        (instruction-interpret (??binoperator) (vector (list 1 2)))
        )
      )))
M
