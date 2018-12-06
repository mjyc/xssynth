#lang rosette

(require "lang.rkt")

(provide (all-defined-out))

(define ERROR 'error)
(define COMPLETE 'complete)
(define EMPTY 'empty)
(define (EMPTY? x) (equal? x 'empty))


(struct V (m) #:transparent)  ; TODO: add  '(q a i)
(struct T (w m) #:transparent)  ; TODO: add  '(q qa i)

(struct srsm (S S0 Sf V V0 SIG ; LAM
  T) #:transparent)


(define SELF_TRANSITION (cons EMPTY -1))
(define REJECT_TRANSITION (cons ERROR -1))

(define default-states
  (list 'monologue 'question 'answer ERROR))  ; ERROR for rejection state
(define default-inputs
  (list 'start 'speechsynth-done EMPTY))  ; EMPTY for no event


(define (answers->inputs answers)
  (for/list ([answer answers])
    (string-join (list "speechrecog-done" "-" answer) ""))
  )

(define (svar-replace-consts prev-svar svar)
  (cond
    [(equal? prev-svar SELF_TRANSITION) svar]  ; TODO factor out
    [(equal? prev-svar REJECT_TRANSITION) '()]
    [else svar]))

(define (srsm-step m s var in)
  (cond
    [(and (equal? s 'wait) (equal? in 'start))
      (define trans (T-w (srsm-T m)))
      (define input-idx (index-of (srsm-SIG m) in))
      (svar-replace-consts (list-ref trans input-idx) (cons s var))
      ]
    [else
      (printf "Undefined transition s ~s var ~a in ~a~%" s var in)
      (cons s var)]
    )
  )

(define (srsm-run m ins)
  (define s0 (srsm-S0 m))
  (define v0 (srsm-V0 m))

  (define (fold acc lst)
    (cond
      [(empty? lst) '()]
      [else
        (define x (first lst))
        (define v
          (if (EMPTY? x) acc (srsm-step m (car acc) (cdr acc) x)))
        (displayln v)
        (cons v (fold v (rest lst)))
        ]
      )
    )
  (fold (cons s0 v0) ins)
  )
