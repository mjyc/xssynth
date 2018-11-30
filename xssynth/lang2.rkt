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


(struct register (index) #:transparent)
(struct program (numinputs instructions) #:transparent)


; Semantics

(define (register-interpret reg lookup)
  (define idx (register-index reg))
  (vector-ref lookup idx))

(define (binfactory-interpret fact lookup)
  (define arg1 (register-interpret (binfactory-arg1 fact) lookup))
  (define arg2 (register-interpret (binfactory-arg2 fact) lookup))
  (cond
    [(xsmerge? fact)
      (map
        (lambda (event1 event2) (if (empty? event2) event1 event2))
        arg1 arg2)
      ]))

(define (unoperator-interpret op lookup)
  (define arg$ (register-interpret (operator-arg$ op) lookup))
  (cond
    [(xsmapTo? op)
      (define c (unoperator-arg1 op))
      (map (lambda (x) (if (empty? x) empty c)) arg$)
      ]))

(define (instruction-interpret inst lookup)
  (cond
    [(binfactory? inst) (binfactory-interpret inst lookup)]
    [(unoperator? inst) (unoperator-interpret inst lookup)]))

(define (program-interpret inst inputs)
  (unless (= (program-numinputs prog) (length inputs))
    (error 'interpret "expected ~a inputs, given ~a" (program-numinputs prog) inputs))
  (define insts (program-instructions prog))
  (define size (+ (length inputs) (length insts)))

  (define lookup (make-vector size))

  (for ([(input i) (in-indexed inputs)])
    (vector-set! lookup i input))

  (for ([inst insts] [i (in-range (length inputs) (vector-length lookup))])
    (vector-set!
      lookup
      i
      (instruction-interpret inst (vector-take lookup (add1 i)))))

  lookup
  )


(define prog
  (program
    2
    (list
      (xsmapTo (register 0) 1)
      (xsmapTo (register 1) -1)
      (xsmerge (register 2) (register 3))
      )))

(define inputs
  (list
    (list 'click empty 'click empty)
    (list empty 'click empty 'click)
    ))

(program-interpret (program 2 prog) inputs)
