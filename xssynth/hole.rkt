#lang rosette

(require rosette/lib/angelic)

(provide (all-defined-out))


(define (??constant)
  (define-symbolic* int integer?)
  (define-symbolic* bool boolean?)
  (choose* int bool))

(define (??stream constructor size)
  (define-symbolic* bool boolean?)
  (for/list ([i size])
    (if bool
      (constructor)
      empty)))  ; empty-event

(define (xsmerge arg1 arg2)
  (map
    (lambda (event1 event2) (if (empty? event2) event1 event2))
    arg1 arg2))

(define (??binfactory arg1 arg2)
  (choose*
    (xsmerge arg1 arg2)))

(define (xsmapTo arg$ arg1)
  (map
    (lambda (x) (if (empty? x) empty arg1))
    arg$))

(define (??unoperator arg$ arg1)
  (choose*
    (xsmapTo arg$ arg1)))

(define (??instruction regs)
  (define r1 (apply choose* regs))
  (define r2 (apply choose* regs))
  (choose* (??binfactory r1 r2) (??unoperator r1 r2)))


; (define (??program size inputs)
;   ; warn
;   (define regs inputs)
;   (for/list [i size]
;     (append regs (??instruction regs)))
;   )

; Example
; (define reg (??stream (lambda () 'click) 10))

(define inputs (list (list 'click empty) (list empty' click)))

(define (prog inputs)
  (define regs inputs)

  (define instructions
    (list xsmerge))  ; index?

  (append regs (for/list ([(inst i) (in-indexed instructions)])
    (inst (list-ref regs 0) (list-ref regs 1))
    ))
  ; regs
  )

(prog inputs)
