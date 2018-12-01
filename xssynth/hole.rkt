#lang rosette

(require
  rosette/lib/angelic
  "lang.rkt"
  ; (rename-in (only-in rosette/query/debug define/debug) [define/debug define])
  )

(provide (all-defined-out))


; Symbolic Syntax

(define (??constant)
  (define-symbolic* ci integer?)
  (define-symbolic* cb boolean?)
  (choose* ci cb))

(define (??stream constructor size)
  (define-symbolic* sb boolean?)
  (for/list ([i size])
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

(define (??inputs constructor input-size n)
  (build-list n (lambda (x) (??stream constructor input-size))))
