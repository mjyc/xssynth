#lang rosette

(require rosette/lib/angelic  ; provides `choose*`
         rosette/lib/match)   ; provides `match`


; ------
; Syntax
; ------

; A tiny subset of xstream API
;   * https://github.com/staltz/xstream


; Stream as a list of events over discrete timesteps

(struct empty-event () #:transparent)

; simplified version of xstream's Stream
;   * events is a list, e.g., '(1 (empty-event) 2 ...)
;   * https://github.com/staltz/xstream#stream
(struct stream (events) #:transparent)

; simplified version of xstream's MemoryStream
;   * init is a memory(-stream)'s initial value of and values is a list
;     representing memory(-stream)'s current values
;   * https://github.com/staltz/xstream#memorystream
(struct memory (values [init #:auto]) #:transparent #:auto-value (empty-event))


; Instruction as a register definition

(struct instruction () #:transparent)
(struct unary instruction (r1) #:transparent)          ; unary instruction
(struct binary instruction (r1 r2) #:transparent)      ; binary instruction
(struct ternary instruction (r1 r2 r3) #:transparent)  ; ternary instruction

; a subset of xstream's Factories
;   * https://github.com/staltz/xstream#factories
(struct of unary () #:transparent)
(struct merge binary () #:transparent)

; a subset of xstream's Operators
;   * https://github.com/staltz/xstream#operators
(struct startWith binary () #:transparent)
(struct map binary () #:transparent)
(struct mapTo binary () #:transparent)
(struct fold ternary () #:transparent)
(struct remember unary () #:transparent)


; Helpers

; shortcuts for instruction accessors
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

; returns true iff the given register is read by any of the given instructions
(define (used? reg insts)
  (ormap
   (lambda (inst)
     (match inst
       [(unary r1) (= r1 reg)]
       [(binary r1 r2) (or (= r1 reg) (= r2 reg))]
       [(ternary r1 r2 r3) (or (= r1 reg) (= r2 reg) (= r3 reg))]))
   insts))



;; ----------------
;; Semantics

;; Stream
(define (mergeE evt-stream1 evt-stream2)
  (map (lambda (evt1 evt2) (if (empty-event? evt2) evt1 evt2))
       evt-stream1 evt-stream2))

(define (constantE const evt-stream)
  (map (lambda (x) (if (empty-event? x) 'no-evt const)) evt-stream))

(define (mergeE evt-stream1 evt-stream2)
  (map (lambda (evt1 evt2) (if (empty-event? evt2) evt1 evt2))
       evt-stream1 evt-stream2))

; The interpreter
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
      [(merge r1 r2) (store idx (mergeE r1 r2))]
      ))
  (load (- size 1))
  )


; (define prog
;   (program 0 (list (mapTo 1 '(no-evt no-evt no-evt click)))))
(define prog
  (program 0 (list (merge '(no-evt no-evt hello click) '(no-evt no-evt no-evt click)))))
(interpret prog '())
