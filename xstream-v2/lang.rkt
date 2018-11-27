#lang rosette

(require rosette/lib/angelic  ; provides `choose*`
         rosette/lib/match)   ; provides `match`


;; Syntax

; (struct stream ())


(struct instruction () #:transparent)
(struct unary instruction (r1) #:transparent)          ; unary instruction
(struct binary instruction (r1 r2) #:transparent)      ; binary instruction
(struct ternary instruction (r1 r2 r3) #:transparent)  ; ternary instruction

(struct program (inputs instructions) #:transparent)


; Factories
(struct merge (stream1 stream2) #:transparent)

; Operators
(struct mapTo (value stream) #:transparent)

; (define prog (mapTo 1 '(no-evt no-evt no-evt no-evt)))
; (mapTo 1 '(no-evt no-evt no-evt no-evt))
; prog


(define prog
  (program 0 (list (mapTo 1 '(no-evt no-evt no-evt no-evt)))))
; (program-inputs prog)

;; Semantics

(define (interpret prog inputs)
  (unless (= (program-inputs prog) (length inputs))
    (error 'interpret "expected ~a inputs, given ~a" (program-inputs prog) inputs))
  (define insts (program-instructions prog))
  (define size (+ (length inputs) (length insts)))
  (define reg (make-vector size))
  ; (displayln insts)
  ; (displayln size)
  ; (displayln reg)
  ; (define (store i v) (vector-set! reg i (finitize v)))
  (define (store i v) (vector-set! reg i v))

  (define (load i)
    (printf "reg ~a~%" reg)
    (vector-ref reg i))

  (printf "before reg ~a~%" reg)
  (for ([(in i) (in-indexed inputs)])
    (store i in))
  (printf "init reg ~a~%" reg)

  (for ([inst insts] [idx (in-range (length inputs) (vector-length reg))])
    (printf "inst ~a~%" inst)
    (match inst
      [_ (store idx '(1 1 1 1))]
      ))
  (load (- size 1))
  )


(interpret prog '())
