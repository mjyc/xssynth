#lang rosette

(require "lang.rkt")

(provide (all-defined-out))

(define EMPTY 'empty)
(define (EMPTY? x) (equal? x 'empty))


(struct V (m) #:transparent)  ; TODO: add  '(q a i)
(struct T (w m) #:transparent)  ; TODO: add  '(q qa i)

(struct srsm (S S0 Sf Sr V V0 SIG ; LAM
  T) #:transparent)


(define default-states
  (list 'monologue 'question 'answer))
(define default-inputs
  (list 'start 'speechsynth-done EMPTY))  ; EMPTY for no event
(define default-outputs
  (list EMPTY))  ; EMPTY for no output


(define (answers->inputs answers)
  (for/list ([answer answers])
    (string-join (list "speechrecog-done" "-" answer) ""))
  )

(define (svar-replace-consts prev-svar svar)
  (cond
    [(equal? svar (cons 'empty -1)) prev-svar]  ; TODO factor out
    [(equal? svar (cons 'error -1)) '()]
    [else svar]))

(define (srsm-get-output m s var)
  (cond
    [(equal? s 'monologue)
      (list-ref (V-m (srsm-V m)) var)]
    [else
      'empty]))

(define (srsm-step m prev-s prev-var in)
  (printf "Start s ~s var ~a in ~a~%" prev-s prev-var in)
  (cond
    [(and (equal? prev-s 'wait) (equal? in 'start))
      (define trans (T-w (srsm-T m)))
      (define input-idx (index-of (srsm-SIG m) in))
      (define svar
        (svar-replace-consts (cons prev-s prev-var) (list-ref trans input-idx)))
      (list (car svar) (cdr svar) (srsm-get-output m (car svar) (cdr svar)))
      ]
    [(and (equal? prev-s 'monologue) (equal? in 'speechsynth-done))
      (define trans (T-m (srsm-T m)))
      (define svar
        (svar-replace-consts (cons prev-s prev-var) (list-ref trans prev-var)))
      (list (car svar) (cdr svar) (srsm-get-output m (car svar) (cdr svar)))
      ]
    [else
      (printf "Undefined transition s ~s var ~a in ~a~%" prev-s prev-var in)
      (list prev-s prev-var EMPTY)]
    )
  )

(define (srsm-run m ins)
  (define s0 (srsm-S0 m))
  (define v0 (srsm-V0 m))

  (define (fold f acc lst)
    (cond
      [(empty? lst) '()]
      [else
        (define x (first lst))
        (define v (f x acc))
        (cond
          [(equal? (first v) 'error) #f]
          [(equal? (first v) 'complete) (list v)]
          [else
            (cons v (fold f v (rest lst)))]
          )
        ]
      )
    )
  (fold
    (lambda (x acc)
      (if (equal? x 'empty) acc (srsm-step m (first acc) (second acc) x)))
    (list s0 v0 EMPTY)
    ins))

