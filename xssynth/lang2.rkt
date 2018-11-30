#lang racket

(provide (all-defined-out))


; Syntax

(struct factory () #:transparent)
(struct binfactory factory (arg1 arg2) #:transparent)

(struct xsmerge binfactory () #:transparent)


(struct operator (arg$) #:transparent)
(struct unoperator operator (arg1) #:transparent)
(struct binoperator operator (arg1 arg2) #:transparent)

(struct xsmap binfactory () #:transparent)
(struct xsmapTo unoperator () #:transparent)
(struct xsstartWith unoperator () #:transparent)
(struct xsfold binoperator () #:transparent)


(struct r (idx) #:transparent)  ; r(esigter)-i(n)d(e)x
(struct program (numinputs instructions) #:transparent)


; Semantics

(define (r-interpret r reg)
  (define i (r-idx r))
  (vector-ref reg i))

(define (binfactory-interpret fact reg)
  (define arg1 (r-interpret (binfactory-arg1 fact) reg))
  (define arg2 (r-interpret (binfactory-arg2 fact) reg))
  (cond
    [(xsmerge? fact)
      (map
        (lambda (event1 event2) (if (empty? event2) event1 event2))
        arg1 arg2)
      ]))

(define (unoperator-interpret op reg)
  (define arg$ (r-interpret (operator-arg$ op) reg))
  (cond
    [(xsmapTo? op)
      (define c (unoperator-arg1 op))
      (map (lambda (x) (if (empty? x) empty c)) arg$)
      ]))

(define (instruction-interpret inst reg)
  (cond
    [(binfactory? inst) (binfactory-interpret inst reg)]
    [(unoperator? inst) (unoperator-interpret inst reg)]))

(define (program-interpret inst inputs)
  (unless (= (program-numinputs prog) (length inputs))
    (error 'interpret "expected ~a inputs, given ~a" (program-numinputs prog) inputs))
  (define insts (program-instructions prog))
  (define size (+ (length inputs) (length insts)))
  (define reg (make-vector size))
  (define (store i v) (vector-set! reg i v))
  (for ([(input i) (in-indexed inputs)])
    (store i input))
  (for ([inst insts] [i (in-range (length inputs) (vector-length reg))])
    (define defined-reg (vector-take reg (add1 i)))
    (store i (instruction-interpret inst defined-reg)))
  reg
  )


; Example program
(define prog
  (program
    2
    (list
      (xsmapTo (r 0) 1)
      (xsmapTo (r 1) -1)
      (xsmerge (r 2) (r 3))
      )))

(define inputs
  (list
    (list 'click empty 'click empty)
    (list empty 'click empty 'click)
    ))

(program-interpret (program 2 prog) inputs)
