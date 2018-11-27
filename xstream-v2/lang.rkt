#lang rosette

(require rosette/lib/angelic  ; provides `choose*`
         rosette/lib/match)   ; provides `match`


;; Syntax

(struct instruction () #:transparent)
(struct unary instruction (r1) #:transparent)          ; unary instruction
(struct binary instruction (r1 r2) #:transparent)      ; binary instruction
(struct ternary instruction (r1 r2 r3) #:transparent)  ; ternary instruction

(struct program (inputs instructions) #:transparent)


; Factories
(struct merge binary () #:transparent)

; Operators
(struct mapTo binary () #:transparent)


(define prog
  (program 0 (list (mapTo 1 '(no-evt no-evt no-evt click)))))


; ------------ shorthands for instruction accessors ------------ ;
(define (r1 v)
  (match v
    [(unary f) f]
    [(binary f _) f]
    [(ternary f _ _) f]))

(define (r2 v)
  (match v
    [(binary _ f) f]
    [(ternary _ f _) f]))

(define r3 ternary-r3)

; Returns true iff the given register is
; read by any of the given instructions.
(define (used? reg insts)
  (ormap
   (lambda (inst)
     (match inst
       [(unary r1) (= r1 reg)]
       [(binary r1 r2) (or (= r1 reg) (= r2 reg))]
       [(ternary r1 r2 r3) (or (= r1 reg) (= r2 reg) (= r3 reg))]))
   insts))

(define pr1 (list-ref (program-instructions prog) 0))
(printf "(binary-r1 pr1) ~a~%" (binary-r1 pr1))
(printf "(binary-r2 pr1) ~a~%" (binary-r2 pr1))



(define NOEVENT 'no-evt)

(define (empty-event? e)
  (eq? NOEVENT e))

(define (not-empty-event? e)
  (not (eq? NOEVENT e)))

(define (constantE const evt-stream)
  (map (λ (x) (if (empty-event? x) 'no-evt const)) evt-stream))

; (program-inputs prog)



; Semantics

(define (interpret prog inputs)
  (unless (= (program-inputs prog) (length inputs))
    (error 'interpret "expected ~a inputs, given ~a" (program-inputs prog) inputs))
  (define insts (program-instructions prog))
  (define size (+ (length inputs) (length insts)))
  (define reg (make-vector size))
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
      [(mapTo r1 r2) (store idx (constantE r1 r2))]
      ))
  (load (- size 1))
  )


(interpret prog '())
