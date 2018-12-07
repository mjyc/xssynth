#lang rosette

(require
  "lang3.rkt"
  rosette/lib/synthax
  rosette/lib/angelic
  )

; Define SRSM

(define init-state 'wait)
(define final-state 'complete)
(define reject-state 'error)
(define states
  (append default-states
    (list init-state final-state reject-state)))

(define variable
  (V
    (list "Hello" "World" "Yay!")  ; monologues
    ))  ; TODO: add questions and answers
(define init-variable 0)

(define inputs default-inputs)

(define transition (T
  (list
    (cons 'monologue 0) ; 'start
    (cons EMPTY -1) ; 'speechsynth-done
    (cons EMPTY -1) ; ?
    )
  (list
    (cons 'monologue 1)
    (cons 'monologue 2)
    (cons 'complete -1)
    )
  ))


(define fsm
  (srsm
    states
    init-state
    final-state
    reject-state
    variable
    init-variable
    inputs
    transition
    ))

(displayln "SRSM:")
fsm


(displayln "")
(displayln "")
(displayln "srsm-step:")
; (srsm-step fsm 'wait 0 'speechsynth-done)
; (srsm-step fsm 'monologue 0 'speechsynth-done)
(srsm-run fsm '(start speechsynth-done speechsynth-done speechsynth-done))
