#lang rosette/safe

(require
  (only-in racket for/list empty)
  "lang.rkt"
  rosette/lib/angelic
  )

(provide (all-defined-out))


; Symbolic Syntax

(define (??constant)
  (define-symbolic* ci integer?)
  (define-symbolic* cb boolean?)
  (choose* ci cb))

(define (??stream constructor size)
  (for/list ([i size])
    (define-symbolic* sb boolean?)
    (if sb
      (constructor)
      empty)))  ; empty-event

(define (??r)
  (define-symbolic* ri integer?)
  (r ri))

(define (??binfactory)
  (choose*
    (xsmerge (??r) (??r)))
    )

(define (??unoperator)
  (choose*
    (xsmapTo (??r) (??constant)))
    )

(define (??binoperator)
  (choose*
    (xsfold (??r) + 0))
    )

(define (??instruction)
  (choose* (??binfactory) (??unoperator) (??binoperator)))
