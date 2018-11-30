#lang rosette

(provide (all-defined-out))


; TODOs
; 1. Define factories
; 2. Define operators



; define array of insts





(define (??instruction insts inputs)
  (define r1 (apply choose* inputs))
  (define r2 (apply choose* inputs))
  (define r3 (apply choose* inputs))
  (apply choose*
         (for/list ([constructor insts])
           (cond [(bv? constructor) constructor] ; baked-in constant
                 [(equal? bv constructor)
                  (local [(define-symbolic* val number?)]
                    (bv val))]
                 [(= 1 (procedure-arity constructor)) (constructor r1)]
                 [(= 2 (procedure-arity constructor)) (constructor r1 r2)]
                 [else (constructor r1 r2 r3)]))))

