#lang racket/base

(provide (all-defined-out))


; ------
; Syntax
; ------

(struct constant (value) #:transparent)

(struct emptyevent () #:transparent)

(struct $ () #:transparent)
(struct stream $ (events) #:transparent)
(struct memory $ (values [init #:auto]) #:transparent #:auto-value (emptyevent))


(struct factory () #:transparent)
(struct binfactory factory (arg1 arg2) #:transparent)

(struct xsmerge binfactory (arg1 arg2))


(struct operator () #:transparent)
(struct unoperator operator (arg1 arg$) #:transparent)
(struct binoperator operator (arg1 arg2 arg$) #:transparent)

(struct xsmap unfactory (arg1 arg$))
(struct xsmapTo unfactory (arg1 arg$))
(struct xsstartWith unfactory (arg1 arg$))
(struct xsfold unfactory (arg1 arg$))
(struct xsremember unfactory (arg1 arg$))


(struct instruction () #:transparent)  ; list of factories & operators


(struct program (numinputs instructions) #:transparent)



; (define (straightline-graph inc dec)
;   (define r1 inc)
;   (define r2 dec)
;   (define r3 (constantE 1 r1))
;   (define r4 (constantE -1 r2))
;   (define r5 (mergeE r3 r4))
;   (define r6 (collectE 0 + r5))
;   (define r7 (startsWith 0 r6))
;   r7)

; r3 (xsmapTo 1 (register 1))
; r4 (xsmapTo -1 (register 2))
; r5 (xsmerge (register 3) (register 4))
; r6 (fold (lambda (acc x) (+ acc x)) 0 r4)
; r6



(define (interpconstant c)
  (unless (or (constant? c) (constant? c))
    (error 'interpconstant "invalid input ~a" c))
  (constant-value c))

; (match inst
;   [(xsmapTo . .) (store ((interpret )))]
;   [(xsmapTo . .) ()]
;   [(xsmapTo . .) ()]
;   [(xsmapTo . .) ()]
;   [(constant v) (load i)]
;   [(lookup i) (load i)]
;   )

; then what? at this point?; implement interpreter, ...,
; ...


; ---------
; Semantics
; ---------


; (define (interpret prog inputs)

;   1. extract inputs
;   2. create registers should be done on

;   (match inst
;     ; [(binfactory arg1 arg2) (store idx (constantE r1 r2))]
;     [(binfactory arg1 arg2) (store idx (constantE r1 r2))]

;     ))
;   )
