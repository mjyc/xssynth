#lang racket/base

(provide (all-defined-out))


; ------
; Syntax
; ------

(struct constant (value) #:transparent)

(struct empty-event () #:transparent)

(struct $ () #:transparent)
(struct stream $ (events) #:transparent)
(struct memory $ (values [init #:auto]) #:transparent #:auto-value (empty-event))


(struct factory () #:transparent)
(struct binfactory factory (arg1 arg2) #:transparent)

(struct xsmerge binfactory (arg1 arg2))


(struct operator (arg$) #:transparent)
(struct unoperator operator (arg1) #:transparent)
(struct binoperator operator (arg1 arg2) #:transparent)

(struct xsmap binfactory (arg1))
(struct xsmapTo unoperator (arg1))
(struct xsstartWith unoperator (arg1))
(struct xsfold binoperator (arg1 arg2))
(struct xsremember factory ())


(struct instruction () #:transparent)  ; list of factories & operators


(struct program (num-inputs instructions) #:transparent)







; ---------
; Semantics
; ---------

(define (constant-interp c)
  (constant-value c))

(define ($-interp s)
  s)

; (define (facotry-interp fact)
;   (match fact
;     [(xsmerge arg1 arg2)
;      (arg1)]))  ; implement it here

; (define (operator-interp op)
;   (match op
;     [(xsmap arg$ arg1)]
;     [(xsmapTo arg$ arg1)]
;     [(xsstartWith arg$ arg1)]
;     [(xsfold arg$ arg2)]
;     [(xsremember arg$)]
;     ))

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





; (define (interpret prog inputs)

;   1. extract inputs
;   2. create registers should be done on

;   (match inst
;     ; [(binfactory arg1 arg2) (store idx (constantE r1 r2))]
;     [(binfactory arg1 arg2) (store idx (constantE r1 r2))]

;     ))
;   )
