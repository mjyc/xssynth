#lang rosette

(require
  "lang3.rkt"
  rosette/lib/synthax
  rosette/lib/angelic
  )

; Define SRSM

(define states (append '(pend) default-states (list COMPLETE)))
(define init-state (list-ref states 0))  ; 'monologue
(define final-state COMPLETE)  ; 'complete

(define variable (V
  (list "Hello" "World" "Yay!")  ; monologues
  ))  ; add questions and answers
; (define init-variable (v (list-ref (v-m variable) 0)))
(define init-variable 0)

(define inputs default-inputs)

(define transition (T
  (list
    (cons 'monologue 0) ; 'start
    SELF_TRANSITION ; 'speechsynth-done
    SELF_TRANSITION ; 'empty
    )
  (list
    (cons 'monologue 1)
    (cons 'monologue 2)
    (cons 'complete 2)
    )
  ))


(define fsm
  (srsm
    states
    init-state
    final-state
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
(srsm-run fsm '(start speechsynth-done speechsynth-done))
