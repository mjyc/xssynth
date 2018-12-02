#lang rosette

(require
  ; "lang.rkt" "hole.rkt"
  ; (only-in rosette/query/debug define/debug debug) rosette/lib/render
  )


; (define (spec input)
;   (unoperator-interpret (xsmapTo input 1) null))

; (define (sketch input)
;   (binoperator-interpret (xsfold input + 0) null))

; (displayln "Verification:")
(define (??stream constructor size)
  (for/list ([i size])
    (define-symbolic* sb boolean?)
    (if sb
      (constructor)
      empty)))  ; empty-event
(define sym-input
  (??stream (lambda () 0) 2))

(map (lambda (x) (if (empty? x) 0 (add1 x))) sym-input)

(define cex (verify (assert (equal?
  (map (lambda (x) (if (empty? x) 0 (add1 x))) sym-input)
  (map (lambda (x) (if (empty? x) 0 (sub1 x))) sym-input)))))
cex

(evaluate sym-input cex)
; (define cex-sym-input (evaluate sym-input cex))
; (spec cex-sym-input)
; (sketch cex-sym-input)


; (displayln "")
; (displayln "Debugging:")
; (render
;   (debug
;     (assert
;       (equal?
;         (spec sym-input)
;         (sketch sym-input)
;         ))
;     )
;   )
