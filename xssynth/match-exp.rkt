#lang racket

(struct expr () #:transparent)
(struct plus expr (left right) #:transparent)
(struct mul expr (left right) #:transparent)

(define (rcur-test inst)
  (match inst
    ; [(expr a b) 0]
    [(plus a b) 0.5]
    [(plus (mul a b) _) 1]
    [(mul (plus a b) _) 2]
    ))

(rcur-test (plus 0 1))

(rcur-test (plus (mul 1 2) 1))
