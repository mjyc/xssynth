#lang rosette

(require
  "lang.rkt"
  "lang2.rkt"
  "hole2.rkt"
  rosette/lib/synthax
  rosette/lib/angelic
  )

; ------------------------------------------------------------------------------
; Program evaluation

(define monologues
  (list "Hello" "world" "Yay!"))

(define (trans in m)
  (??transition
    in m
    (list (cons 'monologue 1) (cons 'monologue 2) (cons 'monologue 0))
    monologues
  ))


(define test-inputs
  (list
    (list
      (input 'speechsynth-done '())
      (input 'speechsynth-done '())
      (input 'speechsynth-done '())
      (input 'speechsynth-done '())
      )
    )
  )

(define prog
  (program
    1
    (list
      (xsfold (r 0) trans (model 'monologue (variables 0) (create-outputs)))
      )))

(displayln "Program evaluation:")
(program-interpret prog test-inputs)


; ------------------------------------------------------------------------------
; Program synthesis

(displayln "")
(displayln "")

(define numinputs 1)
(define inputsize 4)

(define sym-inputs
  (list
    (for/list ([i inputsize])
      (choose* (input 'speechsynth-done '()) '()))
    ))


(define ??trans-tbl (??transition-table monologues))
(define (??trans in m)
  (??transition
    in m
    ??trans-tbl
    monologues
  ))

(define M
  (synthesize
    #:forall (symbolics sym-inputs)
    #:guarantee (assert (equal?
      ; full spec
      (program-interpret (program
        numinputs
        (list
          (xsfold (r 0) trans (model 'monologue (variables 0) (create-outputs)))
          )) sym-inputs)
      ; sketch
      (program-interpret (program
        numinputs
        (list
          (xsfold (r 0) ??trans (model 'monologue  (variables 0) (create-outputs)))
          )) sym-inputs)
      )))
  )

(printf "~%Program synthesis:~%")
(if (sat? M)
  ; M
  ; (print-forms M)
  (evaluate ??trans-tbl M)
  (displayln "No program found"))
