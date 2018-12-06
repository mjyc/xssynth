#lang rosette/safe

(require "lang.rkt")

(provide (all-defined-out))

(define ERROR 'error)
(define COMPLETE 'complete)
(define EMPTY 'empty)


(struct srsm (S S0 Sf Sr V V0 SIG LAM) #:transparent)


; S x I
(define (srsm-step srsm s var in)
  ; (define )
  (cond
    ; [(eqv? s ERROR) '()]
    ; [(eqv? s COMPLETE) '()]
    [(equal? s 'monologue)
      (car (list-ref m-trans-tbl var))  ; next state
      (car (list-ref m-trans-tbl var))  ; next var
      (list s var out)
    ]
    [(empty? inputs) #f]
    ; [else
    ;   (struct rsm '() #:transparent)
    ;   (define result ((automaton-transition machine) state (first inputs)))
    ;   (if (empty? result)
    ;     #f
    ;     (step (first result) (rest inputs) (cons (second result) outputs))
    ;     )]
    ; )
  )


; TODO: "create output set" (let me just start with this now)
; input param sentences
; 'speak-s1...sn
; 'listen&speak-s1...sn

; TODO: "enhance default-states"
; add custom start, end, reject

; TODO: "create input done form "answers"


; (define (srsm-run srsm inputs))

; (define default-states
;   (list 'monologue 'question 'answer COMPLETE ERROR))

; (define default-inputs
;   (list 'speechsynth-done EMPTY))



; step: S x V x  -> S x V x O



(list-ref S 1)



(define (same trans1 trans2 states variables outputs inputs)
  ; create two srsms
  ; run them and
  ;   compare whether one of them CRASHED or not
  ;   compare whether one of them COMPLETED or not
  ;   otherwise, I could compare many things at this point.
  ;   e.g., just compare outputs, or more
  ;   make things super contrained and see what I can synthesize
  (for ([i lenght])
    (inputs)
    )
  )



(define (fsm-run machine input-stream)
  (define (step state inputs outputs)
    (cond
      [(eqv? state S_NONE) #f]
      [(eqv? state (automaton-final-state machine))
       (if (empty? inputs) (reverse outputs) #f)]
      [(empty? inputs) #f]
      [else
        (define result ((automaton-transition machine) state (first inputs)))
        (if (empty? result)
          #f
          (step (first result) (rest inputs) (cons (second result) outputs))
          )]
      ))
  (step (automaton-cur-state machine) input-stream empty)
  )
