#lang racket

(provide (all-defined-out))


; ------
; Syntax
; ------

(struct constant (value) #:transparent)

(struct empty-event () #:transparent)

(struct $ () #:transparent)
(struct stream $ (events) #:transparent)


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
(struct instruction () #:transparent)  ; list of factories & operators


(struct program (num-inputs instructions) #:transparent)







; ---------
; Semantics
; ---------

(define (constant-interpret c)
  (constant-value c))  ; boolean or integer for now

(define ($-interpret s)
  s)  ; just stream for now

(define (register-interpret reg lookup)
  (define idx (register-index reg))
  (unless (< idx (vector-length lookup))
    (error 'register-interpret "invalid input" reg))
  (vector-ref lookup idx))

(define (factory-interpret fact lookup)
  (match fact
    [(xsmerge arg1 arg2)
     (map (lambda (event1 event2) (if (empty-event? event2) event1 event2))
          (stream-events (register-interpret arg1 lookup))
          (stream-events (register-interpret arg2 lookup)))]
    ; TODO: add more factory-interpreters here
    ))

(define (operator-interpret op lookup)
  (match op
    [(xsmapTo arg1 arg2)
     (map (lambda (x) (if (empty-event? x) (empty-event) (constant-interpret arg2)))
          (register-interpret arg1 lookup))]
    ; TODO: add more operator-interpreters here
    ))

(define (instruction-interpret) inst lookup
  (match inst
    [(factory _) (facotry-interpret inst lookup)]
    [(operator _) (operator-interpret inst lookup)]))

; (instruction-interpret (xsmapTo (register 0) (constant 1)  ))

; (define (interpret prog)
;   (define lookup '()) ; add inputs
;   (define insts (program-instructions prog)))
