#lang rosette

(require
  rosette/lib/angelic
  "lang2.rkt")

(provide (all-defined-out))


(define (??constant)
  (define-symbolic* si integer?)
  si)
  ; (define-symbolic* si integer?)
  ; (define-symbolic* sb boolean?)
  ; (choose* si sb))

(define (??stream constructor size)
  (define-symbolic* sb boolean?)
  (for/list ([i size])
    (if sb
      (constructor)
      empty)))  ; empty-event

(define (??r lookup)
  (define-symbolic* si integer?)
  (r si))

(define (??binfactory)
  (choose*
    (xsmerge ??r ??r)))

(define (??unoperator)
  (xsmapTo ??r ??constant))
  ; (choose*
  ;   (xsmapTo ??r ??constant)))

(define (??instruction regs)
  ; (choose* (??binfactory) (??unoperator)))
  (??unoperator))

; (define (??program inputs numinsts)
;   (define size (+ (length inputs) numinsts))
;   (define reg (make-vector size))
;   (define (store i v) (vector-set! reg i v))
;   (define (load i) (vector-ref reg i))
;   (for ([(input i) (in-indexed inputs)])
;     (store i input))

;   (for ([i (in-range (length inputs) (vector-length reg))])
;     (define defined-reg (vector-take reg (add1 i)))
;     (store i (??instruction defined-reg)))

;   (load (sub1 size))
;   )

(define (??program numinputs numinsts)
  (program
    numinputs
    (for/list ([i numinsts]) ??instruction)
    )
  )

; Example

(define spec
  (program
    2
    (list
      (xsmapTo (r 0) 1)
      ; (xsmapTo (r 1) -1)
      ; (xsmerge (r 2) (r 3))
      )))

(define inputs
  (list
    (list 'click empty 'click empty)
    (list empty 'click empty 'click)
    ))

(program-interpret spec inputs)


(define ??inputs
  (list ??stream ??stream))


(define test-input
  (list
    (list 0 0 0 0)
    ))

(solve
  (assert (equal?
    (program-interpret (??program 1 1) test-input)
    '(1 1 1 1)
    )))

; (synthesize
;   #:forall (symbolics ??inputs)
;   #:guarantee (assert (equal?
;     (program-interpret spec ??inputs)
;     (program-interpret (??program 2 1) ??inputs)
;     )))
