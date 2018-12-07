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


; ------------------------------------------------------------------------------
; Program execution

(displayln "")
(displayln "")
; (displayln "srsm-step:")
; (srsm-step fsm 'wait 0 'speechsynth-done)
; (srsm-step fsm 'monologue 0 'speechsynth-done)
(define test-ins '(start speechsynth-done speechsynth-done speechsynth-done))
(displayln "srsm-run:")
(srsm-run fsm test-ins)



; ------------------------------------------------------------------------------
; Angelic execution

(displayln "")
(displayln "")

; (same transition
;   transition
;   states
;   init-state
;   final-state
;   reject-state
;   variable
;   init-variable
;   inputs
;   '(start speechsynth-done speechsynth-done speechsynth-done))

(define ??trans (T
  (list
    (cons 'monologue 0) ; 'start
    (cons EMPTY -1) ; 'speechsynth-done
    (cons EMPTY -1) ; ?
    )
  (list
    (cons (choose 'wait 'monologue 'complete 'error) 1)
    (cons (choose 'wait 'monologue 'complete 'error) 2)
    (cons 'complete -1)
    )
  ))


(define M (solve
  (assert
    (same transition
  ??trans
  states
  init-state
  final-state
  reject-state
  variable
  init-variable
  inputs
  '(start speechsynth-done speechsynth-done speechsynth-done)))))

(displayln "Angelic execution")
(if (sat? M)
  ; M
  (print-forms M)
  ; (evaluate ??trans-tbl M)
  (displayln "No program found"))



; ------------------------------------------------------------------------------
; Program synthesis

(displayln "")
(displayln "")

(define inputsize 3)  ; 4 doesn't work
(define sym-inputs
  (for/list ([i inputsize])
    (apply choose* '(start speechsynth-done)))
  )


(define M2
  (synthesize
    #:forall (symbolics sym-inputs)
    #:guarantee (same transition
  ??trans
  states
  init-state
  final-state
  reject-state
  variable
  init-variable
  inputs
  (cons 'start sym-inputs))))

(displayln "Program synthesis")
(if (sat? M2)
  ; M2
  (print-forms M2)  ; splits weird outputs!
  ; (evaluate ??trans-tbl M2)
  (displayln "No program found"))
