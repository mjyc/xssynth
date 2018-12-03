#lang rosette

(require
  ; (rename-in
  ;   (only-in rosette/query/debug define/debug)
  ;   [define/debug define]
  ;   )
  )

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

(define (r-interpret v reg)
  (if (r? v)  ; otherwise, assumes it's events
    (vector-ref reg (r-idx v)) v))

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

(define (binoperator-interpret op reg)
  (define arg$ (r-interpret (operator-arg$ op) reg))
  (cond
    [(xsfold? op)
      (define f (binoperator-arg1 op))
      (define s (binoperator-arg2 op))

      (define (fold lst acc)
        (cond
          [(empty? lst) '()]
          [else
            (define x (first lst))
            (define v
              (if (empty? x) acc (f x acc)))
            (cons v (fold (rest lst) v))
            ]
          )
        )
      (fold arg$ s)
      ]))

(define (instruction-interpret inst reg)
  (cond
    [(binfactory? inst) (binfactory-interpret inst reg)]
    [(unoperator? inst) (unoperator-interpret inst reg)]
    [(binoperator? inst) (binoperator-interpret inst reg)]))

(define (program-interpret prog inputs)
  (unless (= (program-numinputs prog) (length inputs))
    (error 'interpret "expected ~a inputs, given ~a" (program-numinputs prog) inputs))
  (define (exec insts reg)
    (cond
      [(empty? insts) reg]
      [else
        (exec
          (rest insts)
          (append reg (list (instruction-interpret (first insts) (list->vector reg))))
          )
        ]
      ))
  (define reg
    (exec (program-instructions prog) inputs))
  (if (or (empty? reg) (= (length reg) (length inputs)))
    empty
    (first (reverse reg)))
  )
