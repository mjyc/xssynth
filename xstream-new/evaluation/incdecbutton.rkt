#lang rosette

(require "../stream.rkt")
(require "../api.rkt")
(require "../operator.rkt")
(require "../sketch.rkt")

(current-bitwidth #f)


; reference solution in straightline/register code style, i.e.,
;   inputs: clicks on + button and clicks on - button
;   output: counter
(define (straightline-graph inc dec)
  (define r1 inc)
  (define r2 dec)
  (define r3 (constantE 1 r1))
  (define r4 (constantE -1 r2))
  (define r5 (mergeE r3 r4))
  ; (define r6 (collectE 0 + r5))
  ; (define r7 (startsWith 0 r6))
  ; r7)
  r5)

; symbolic inputs
(define stream-length 4)
(define sym-increment (new-event-stream (λ () 'click) stream-length))
(define sym-decrement (new-event-stream (λ () 'click) stream-length))

; symbolic sketch
; (define sk (get-symbolic-sketch 5 (list->vector '(#f #f #f #t #t)) 2))
(define sk (get-symbolic-sketch 3 (list->vector '(#f #f #f)) 2))

; synthesize!
(println "Synthesize function against reference implementation")
(define evaled-sk ((get-sketch-function sk) sym-increment sym-decrement))
(define b (time (synthesize #:forall (symbolics (list sym-increment sym-decrement))
                            #:guarantee (assert (equal? evaled-sk (straightline-graph sym-increment sym-decrement))))))
(if (unsat? b)
    (println "no solution for synthesis against reference implementation")
    (print-sketch sk b))
