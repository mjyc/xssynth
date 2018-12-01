#lang rosette

(provide (all-defined-out))


; Syntax

(struct factory () #:transparent)
(struct binfactory factory (arg1 arg2) #:transparent)

(struct xsmerge binfactory () #:transparent)


(struct operator (arg$) #:transparent)
(struct unoperator operator (arg1) #:transparent)
(struct binoperator operator (arg1 arg2) #:transparent)

(struct xsmap unoperator () #:transparent)
(struct xsmapTo unoperator () #:transparent)
(struct xsfold binoperator () #:transparent)


(struct r (idx) #:transparent)  ; r(esigter)-i(n)d(e)x
(struct program (numinputs instructions) #:transparent)


; Semantics

(define (r-interpret r reg)
  (if (r? reg)  ; otherwise, assumes it's events
    (vector-ref reg (r-idx r)) r))

(define (constant? x)
  (or (integer? x) (boolean? x)))

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
    [(xsmap? op)
      (define f (unoperator-arg1 op))
      (map (lambda (x) (if (empty? x) x (f x))) arg$)
      ]
    [(xsmapTo? op)
      (define c (unoperator-arg1 op))
      (map (lambda (x) (if (empty? x) empty c)) arg$)
      ]))

(define (instruction-interpret inst reg)
  (cond
    [(binfactory? inst) (binfactory-interpret inst reg)]
    [(unoperator? inst) (unoperator-interpret inst reg)]))

(define (program-interpret prog inputs)
  (unless (= (program-numinputs prog) (length inputs))
    (error 'interpret "expected ~a inputs, given ~a" (program-numinputs prog) inputs))
  (define insts (program-instructions prog))
  (define size (+ (length inputs) (length insts)))
  (define reg (make-vector size))
  (define (store i v) (vector-set! reg i v))
  (define (load i) (vector-ref reg i))
  (for ([(input i) (in-indexed inputs)])
    (store i input))
  (for ([inst insts] [i (in-range (length inputs) (vector-length reg))])
    (define defined-reg (vector-take reg (add1 i)))
    (store i (instruction-interpret inst defined-reg)))
  (load (sub1 size))
  )
