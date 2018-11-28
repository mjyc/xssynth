#lang rosette

(require rosette/lib/angelic  ; provides `choose*`
         rosette/lib/match)   ; provides `match`

(provide (all-defined-out))


; ------
; Syntax
; ------

; A tiny subset of xstream API
;   * https://github.com/staltz/xstream


; Stream as list of events over discrete timesteps

(struct empty-event () #:transparent)

; simplified version of xstream's Stream
;   * events is the list representing events over discrete timesteps,
;     e.g., '(1 (empty-event) 2 ...)
;   * https://github.com/staltz/xstream#stream
(struct stream (events) #:transparent)

; simplified version of xstream's MemoryStream
;   * init is the memory(-stream)'s initial value of and values is the list
;     representing memory(-stream)'s current values over discrete timesteps
;   * https://github.com/staltz/xstream#memorystream
(struct memory (values [init #:auto]) #:transparent #:auto-value (empty-event))


; Instruction as register definition

(struct instruction () #:transparent)
(struct unary instruction (r1) #:transparent)          ; unary instruction
(struct binary instruction (r1 r2) #:transparent)      ; binary instruction
(struct ternary instruction (r1 r2 r3) #:transparent)  ; ternary instruction

; a tiny subset of xstream's Factories
;   * https://github.com/staltz/xstream#factories
; (struct xsof unary () #:transparent)
(struct xsmerge binary () #:transparent)

; a tiny subset of xstream's Operators
;   * https://github.com/staltz/xstream#operators
(struct xsstartWith binary () #:transparent)
(struct xsmapTo binary () #:transparent)
(struct xsfold ternary () #:transparent)
(struct xsremember unary () #:transparent)


; Program as list of instructions

; inputs is the number of the program inputs
(struct program (inputs instructions) #:transparent)



;; ----------------
;; Semantics

(define (interpret-xsmerge r1 r2)
  (define r1-events (if (memory? r1) (memory-values r1) (stream-events r1)))
  (define r2-events (if (memory? r2) (memory-values r2) (stream-events r2)))
  (stream (map (lambda (event1 event2) (if (empty-event? event2) event1 event2))
       r1-events r2-events)))

; (define (interp-xsmapTo r1 r2)
;   (define f (lambda (x) (if (empty-event? x) (empty-event) const)))
;   (cond [(stream? r2) (map f (stream-events r2))]
;         [else (map f (memory-values r2))]))

; (define (interp-startWith r1 r2 r3)
;   (define f (lambda (x) (if (empty-event? x) (empty-event) const)))
;   (cond [(stream? r2) (map f (stream-events r2))]
;         [else (map f (memory-values r2))]))

; (define (interp-map r1 r2 r3)
;   (define f (lambda (x) (if (empty-event? x) (empty-event) const)))
;   (cond [(stream? r2) (map f (stream-events r2))]
;         [else (map f (memory-values r2))]))

; (define (interp-mapTo r1 r2 r3)
;   (define f (lambda (x) (if (empty-event? x) (empty-event) const)))
;   (cond [(stream? r2) (map f (stream-events r2))]
;         [else (map f (memory-values r2))]))

; (define (interp-fold r1 r2 r3)
;   (define f (lambda (x) (if (empty-event? x) (empty-event) const)))
;   (cond [(stream? r2) (map f (stream-events r2))]
;         [else (map f (memory-values r2))]))

; ;; Stream
; (define (constantE const evt-stream)
;   (map (lambda (x) (if (empty-event? x) 'no-evt const)) evt-stream))

; (define (mergeE evt-stream1 evt-stream2)
;   (map (lambda (evt1 evt2) (if (empty-event? evt2) evt1 evt2))
;        evt-stream1 evt-stream2))

; ; The interpreter
; (define (interpret prog inputs)
;   (unless (= (program-inputs prog) (length inputs))
;     (error 'interpret "expected ~a inputs, given ~a" (program-inputs prog) inputs))
;   (define insts (program-instructions prog))
;   (define size (+ (length inputs) (length insts)))
;   (define reg (make-vector size))
;   (define (store i v) (vector-set! reg i v))

;   (define (load i)
;     (printf "reg ~a~%" reg)
;     (vector-ref reg i))

;   (printf "before reg ~a~%" reg)
;   (for ([(in i) (in-indexed inputs)])
;     (store i in))
;   (printf "init reg ~a~%" reg)

;   (for ([inst insts] [idx (in-range (length inputs) (vector-length reg))])
;     (printf "inst ~a~%" inst)
;     (match inst
;       [(mapTo r1 r2) (store idx (constantE r1 r2))]
;       [(merge r1 r2) (store idx (mergeE r1 r2))]
;       ))
;   (load (- size 1))
;   )


; ; (define prog
; ;   (program 0 (list (mapTo 1 '(no-evt no-evt no-evt click)))))
; (define prog
;   (program 0 (list (merge '(no-evt no-evt hello click) '(no-evt no-evt no-evt click)))))
; (interpret prog '())
