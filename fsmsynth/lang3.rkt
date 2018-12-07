#lang rosette

(require "lang.rkt" rosette/lib/lift)

(provide (all-defined-out))

(define EMPTY 'empty)
(define (EMPTY? x) (equal? x 'empty))


(struct V (m) #:transparent)  ; TODO: add  '(q a i)
(struct T (w m) #:transparent)  ; TODO: add  '(q qa i)

(struct srsm (S S0 Sf Sr V V0 SIG ; LAM  ; TODO: add  LAM
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

(define (s-replace-empty s prev-s)
  (if (EMPTY? s) prev-s s))

(define (srsm-get-output m s var)
  (cond
    [(equal? s 'monologue)
      (list-ref (V-m (srsm-V m)) var)]
    [else
      'empty]))


(define-lift lifted-index-of-sym
  [(list? symbol?) index-of])

(define-lift lifted-index-of-bool
  [(list? boolean?) index-of])

(define (srsm-step m prev-s prev-var in)
  ; (printf "srsm-step s ~s var ~a in ~a~%" prev-s prev-var in)
  (cond
    [(and (equal? prev-s 'wait) (equal? in 'start))
      (define trans (T-w (srsm-T m)))
      (define input-idx (lifted-index-of-sym (srsm-SIG m) in))
      (define s (s-replace-empty (car (list-ref trans input-idx)) prev-s))
      (define var (cdr (list-ref trans input-idx)))
      (list s var (srsm-get-output m s var))
      ]
    [(and (equal? prev-s 'monologue) (equal? in 'speechsynth-done))
      (define trans (T-m (srsm-T m)))
      (define s (s-replace-empty (car (list-ref trans prev-var)) prev-s))
      (define var (cdr (list-ref trans prev-var)))
      (list s var (srsm-get-output m s var))
      ]
    [else
      ; (printf "Undefined transition s ~s var ~a in ~a~%" prev-s prev-var in)
      (list prev-s prev-var EMPTY)
      ]))

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
          [(equal? (first v) (srsm-Sr m)) (list #f)]
          [(equal? (first v) (srsm-Sf m)) (list (srsm-Sf m))]
          [else
            (cons v (fold f v (rest lst)))]
          )
        ]))
  (define result (fold
      (lambda (x acc)
        (if (equal? x 'empty) acc (srsm-step m (first acc) (second acc) x)))
      (list s0 v0 EMPTY)
      ins))
  result
  ; (if (lifted-index-of-bool result #f) #f result)
  )


(define (same t1 t2 s s0 sf sr v v0 sig ins)
  (define m1 (srsm s s0 sf sr v v0 sig t1))
  (define m2 (srsm s s0 sf sr v v0 sig t2))

  (equal? (srsm-run m1 ins) (srsm-run m2 ins)))
  ; (define r1 (srsm-run m1 ins))
  ; (define r2 (srsm-run m2 ins))
  ; (and r1
  ;   (and r2
  ;     (equal? r1 r2)
  ;     )))
