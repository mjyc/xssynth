#lang rosette

(require
  rosette/lib/angelic
  "lang2.rkt")

(provide (all-defined-out))


(define (??constant)
  (define-symbolic* si integer?)
  (define-symbolic* sb boolean?)
  (choose* si sb))

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
    (xsmerge (??r) (??r))))

(define (??unoperator)
  (choose*
    (xsmapTo (??r) (??constant))))

(define (??instruction)
  (choose* (??binfactory) (??unoperator)))

; TODO: update it to ??instructions
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
      (xsmapTo (r 1) -1)
      (xsmerge (r 2) (r 3))
      )))

(define inputs
  (list
    (list 'click empty 'click empty)
    (list empty 'click empty 'click)
    ))

; (program-interpret spec inputs)


(define (??inputs constructor size n)
  (build-list n (lambda (x) (??stream constructor size))))


(program-interpret (program 2 (list
  (xsmapTo (r 0) 1)
  (xsmapTo (r 1) 1)
  (xsmerge (r 2) (r 3))
  )) inputs)


(define sketch (??program 2 3))
(define sinputs (??inputs (lambda (x) 'click) 4 2))

(define M
  (synthesize
    #:forall (symbolics sinputs)
    #:guarantee (assert (equal?
      (program-interpret spec sinputs)
      (program-interpret sketch sinputs)
      )))
)

sketch
M
(evaluate sketch M)
