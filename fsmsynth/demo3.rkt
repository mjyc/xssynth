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
  (list "You are an ice cream lover!" "You are a donut lover!" "You don't like ice cream and donut!"))

(define questions
  (list "Do you like ice cream?" "Do you like donut?"))

(define answers
  (list 'yes 'no))

(define (trans in m)
  (??transition
    in m
    (list  ; Monologue trans-tbl
      (cons 'monologue 0)  ; M1
      (cons 'monologue 1)
      (cons 'monologue 2)
      )
    (list  ; Q&A trans-tbl
      (list  ; Q0,
        (cons 'monologue 0)  ; A0
        (cons 'question 1) ; A1
      )
      (list  ; Q1,
        (cons 'monologue 1)  ; A0
        (cons 'monologue 2) ; A1
      )
      )
    monologues
    questions
    answers
  ))

(define test-inputs
  (list
    (list
      (input 'speechsynth-done '()) ; first question done & wait for answer
      (input 'speechrecog-done 'no)  ; heard yes, moving to "M1"
      (input 'speechsynth-done '())  ; You are an ice cream lover!
      (input 'speechrecog-done 'yes)
      )
    )
  )

(define prog
  (program
    1
    (list
      (xsfold (r 0) trans (model 'question (variables 0) (create-outputs (list-ref questions 0))))
      )))

(displayln "Program evaluation:")
(program-interpret prog test-inputs)


; ; ------------------------------------------------------------------------------
; ; Program synthesis

; (displayln "")
; (displayln "")

; (define numinputs 1)
; (define inputsize 4)

; (define sym-inputs
;   (list
;     (for/list ([i inputsize])
;       (choose* (input 'speechsynth-done '()) '()))
;     ))


; (define ??trans-tbl (??transition-table monologues))
; (define (??trans in m)
;   (??transition
;     in m
;     ??trans-tbl
;     monologues
;   ))

; (define M
;   (synthesize
;     #:forall (symbolics sym-inputs)
;     #:guarantee (assert (equal?
;       ; full spec
;       (program-interpret (program
;         numinputs
;         (list
;           (xsfold (r 0) trans (model 'monologue (variables 0) (create-outputs)))
;           )) sym-inputs)
;       ; sketch
;       (program-interpret (program
;         numinputs
;         (list
;           (xsfold (r 0) ??trans (model 'monologue  (variables 0) (create-outputs)))
;           )) sym-inputs)
;       )))
;   )

; (printf "~%Program synthesis:~%")
; (if (sat? M)
;   ; M
;   ; (print-forms M)
;   (evaluate ??trans-tbl M)
;   (displayln "No program found"))
