#lang rosette

(require
  "lang3.rkt"
  rosette/lib/synthax
  rosette/lib/angelic
  )

; Define SRSM

(define init-state 'wait)
(define final-state 'complete)
(define states
  (append default-states
    (list init-state final-state)))

(define variable
  (V
    (list "Hello" "World" "Yay!")  ; monologues
    ))  ; TODO: add questions and answers
(define init-variable 0)

(define inputs default-inputs)

(define transition (T
  (list
    (cons 'monologue 0)
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
(define test-ins
  '(start speechsynth-done start speechsynth-done speechsynth-done speechsynth-done)
  ; '(start start start start speechsynth-done speechsynth-done)
  )
(displayln "Program execution:")
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
;   variable
;   init-variable
;   inputs
;   '(start speechsynth-done speechsynth-done speechsynth-done))

(define ??trans (T
  (list
    (cons 'monologue 0) ; 'start
    (cons 'wait 1) ; 'speechsynth-done
    (cons 'wait 2) ; ?
    )
  (list
    (cons (choose 'wait 'monologue 'complete) 1)
    (cons (choose 'wait 'monologue 'complete) 2)
    (cons 'complete -1)
    )
  ))
; ??trans


(define M (solve
  (assert
    (same transition
  ??trans
  states
  init-state
  final-state
  variable
  init-variable
  inputs
  test-ins))))

(displayln "Angelic execution")
(if (sat? M)
  (begin
    (displayln M)
    (print-forms M)
    )
  ; (evaluate ??trans-tbl M)
  (displayln "No program found"))



; ------------------------------------------------------------------------------
; Program synthesis

(displayln "")
(displayln "")

(define inputsize 8)
(define sym-ins
  (for/list ([i inputsize])
    (apply choose* '(start speechsynth-done)))
  )


(define M2
  (synthesize
    #:forall (symbolics sym-ins)
    #:guarantee (same transition ??trans
      states init-state final-state variable init-variable inputs
      (cons 'start (append sym-ins)))))

(displayln "Program synthesis")  ; PROBLEM! the synthesizer finds a result that does not make sense!
(if (sat? M2)
  (begin
    (printf "M2 ~a~%" M2)
    (print-forms M2)  ; splits weird outputs!
    )
  (displayln "No program found"))


; ------------------------------------------------------------------------------
; Try verification

(displayln "")
(displayln "")

(define cex (verify
  (assert
    (same
      transition
      (T
        (list
          (cons 'monologue 0) ; 'start
          (cons 'wait 1) ; 'speechsynth-done
          (cons 'wait 2) ; ?
          )
        (list
          (cons 'monologue 1)
          (cons 'monologue 2)
          (cons 'complete -1)
          )
        )
      states
      init-state
      final-state
      variable
      init-variable
      inputs
      (cons 'start (append sym-ins))))
  ))

(printf "~%Verification~%")
cex
(if (sat? cex)
  ; cex
  (begin
    (print-forms cex)
    (evaluate sym-ins cex))
  (displayln "No counterexample found"))
