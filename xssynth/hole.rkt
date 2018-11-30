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

(define (??r)
  (define-symbolic* si integer?)
  (r si))

(define (??binfactory)
  (choose*
    (xsmerge ??r ??r)))

(define (??unoperator)
  (choose*
    (xsmapTo (??r) (??constant))))

(define (??instruction)
  (choose* (??binfactory) (??unoperator)))

(define (??program numinputs numinsts)
  (program
    numinputs
    (for/list ([i numinsts]) (??instruction))
    ))


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

; (solve
;   (assert (equal?
;     (??r)
;     (r 10))))

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
