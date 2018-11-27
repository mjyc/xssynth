#lang rosette

(require "stream.rkt")

(provide (all-defined-out))


; TODO: rename it to never
(define (zeroE) '())

; is it better to return e or no-evt if event is empty?
(define (mapE proc evt-stream)
  (map (λ (e) (if (empty-event? e) e (proc e))) evt-stream))

(define (mapE2 proc evt-stream1 evt-stream2)
  (map (λ (e1 e2) (if (or (empty-event? e1) (empty-event? e2)) 'no-evt (proc e1 e2))) evt-stream1 evt-stream2))

(define (mergeE evt-stream1 evt-stream2)
  (map (λ (evt1 evt2) (if (empty-event? evt2) evt1 evt2))
       evt-stream1 evt-stream2))

(define (filterE pred stream)
  (map (λ (e) (if (and (not-empty-event? e) (pred e)) e 'no-evt)) stream))

; TODO: rename to mapTo
(define (constantE const evt-stream)
  (map (λ (x) (if (empty-event? x) 'no-evt const)) evt-stream))

; TODO: rename to fold
(define (collectE init proc lst)
  (for/list ([i (range (length lst))])
    (if (empty-event? (list-ref lst i))
        'no-evt
        (foldl (λ (n m) (if (empty-event? n) m (proc n m))) init (take lst (add1 i))))))

(define (collectE-plus init stream)
  (map (λ (s n) (if (empty-event? s) 'no-evt n))
       stream
       (list-tail (reverse (foldl (λ (n lst) (cons (if (empty-event? n) (first lst) (+ n (first lst))) lst))
                                  (list init) stream)) 1)))
(define (collectE-minus init stream)
  (map (λ (s n) (if (empty-event? s) 'no-evt n))
       stream
       (list-tail (reverse (foldl (λ (n lst) (cons (if (empty-event? n) (first lst) (- n (first lst))) lst))
                                  (list init) stream)) 1)))

(define (filterRepeatsE evt-stream)
  (letrec ([f (λ (evt rest)
                (cond [(empty? rest) evt]
                      [(equal? evt (first rest)) 'no-evt]
                      [(not-empty-event? (first rest)) evt]
                      [else (f evt (cdr rest))]))])
    (for/list ([i (range 1 (add1 (length evt-stream)))])
      (let ([lst (take evt-stream i)])
        (if (empty-event? (last lst))
            'no-evt
            (f (last lst) (cdr (reverse lst))))))))

(define (startsWith init-value evt-stream)
  (behavior init-value (for/list ([i (range (length evt-stream))])
                         (findf (λ (e) (not (empty-event? e)))
                                (reverse (cons init-value (take evt-stream (add1 i))))))))

; ; TODO: rename it to remember
; (define (changes behaviorB)
;     (filterRepeatsE (behavior-changes behaviorB)))
