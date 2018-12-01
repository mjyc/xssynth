#lang rosette

(require
  "lang.rkt"
  "hole.rkt")


(define inputs
  (list
    (list 1 1 1 1)
    ))

(define spec
  (program
    (length inputs)
    (list
      (xsfold (r 0) + 0)
      )))

(define sketch
  (program
    (length inputs)
    (list
      (??instruction))
    ))

(displayln "Spec evaluation:")
(program-interpret spec inputs)


(define M
  (solve
    (assert
      (equal?
        spec
        sketch
        ; (program-interpret spec inputs)  ; this doesn't work! why?
        ; (program-interpret sketch inputs)  ; this doesn't work! why?
        )))
  )

(displayln "Synthesized syntax:")
(evaluate sketch M)


(displayln "")

(displayln "instruction-interpret:")
(instruction-interpret
  (first (program-instructions sketch))
  (list->vector inputs)
  )

(displayln "Synthesis output:")
(define M2
  (solve
    (assert
      (equal?
        (program-interpret spec inputs)  ; this doesn't work! why?
        (program-interpret sketch inputs)  ; this doesn't work! why?

        ; ; (binoperator-interpret
        ; (instruction-interpret
        ;   (first (program-instructions spec))
        ;   ; (vector (list 1 2))
        ;   (list->vector inputs)
        ;   )

        ; ; (binoperator-interpret
        ; (instruction-interpret
        ;   (first (program-instructions sketch))
        ;   ; (vector (list 1 2))
        ;   (list->vector inputs)
        ;   )

        )))
  )
M2
