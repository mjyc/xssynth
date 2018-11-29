#lang rosette

(require quickcheck "lang.rkt")


(define generator-empty-event
  (generator (lambda (i rgen) (empty-event))))

(define arbitrary-empty-event
  (arbitrary generator-empty-event
             (lambda (x gen) gen)
             ))

; (define (arbitrary-n-list arbitrary-el)
;   (arbitrary-sequence choose-list values arbitrary-el))

(define arbitrary-events
  (arbitrary-list
    (arbitrary-mixed (list (cons '() arbitrary-integer)
                           (cons '() arbitrary-boolean)
                           (cons '() arbitrary-empty-event)
                           ))))

; (define test-interpret-xsmapTo
;   (property ([events1 arbitrary-events]
;              [events2 arbitrary-events])
;     (printf "1: ~a~%2: ~a~%~%" events1 events2)
;     true))

; (quickcheck test-interpret-xsmapTo)

; (require quickcheck racket/promise)

; (define string->number-returns-number
;     (property ([str arbitrary-string])
;       (number? (string->number str))))

; (quickcheck string->number-returns-number)


; (define test
;     (property ([lst (arbitrary-list arbitrary-integer)])
;       (displayln lst)
;       true))

; (define test2
;     (property ([lst (arbitrary-list (arbitrary (choose-mixed (list (delay (choose-integer 1 10)) (delay (choose-integer 20 30))) ) (lambda (x gen) gen)))])
;       (displayln lst)
;       true))

; (define test3
;     (property ([lst (arbitrary-list (arbitrary-mixed (list   (cons '() arbitrary-integer)   (cons '() arbitrary-boolean)   )))])
;       (displayln lst)
;       true))


; (quickcheck test3)





; (define arbit)

; (define standard-stream (list 1 2 3))


; (define empty-evt-stream '())
; (define stream-with-no-evts (list (list 1 'no-evt) (list 2 "hello") (list 5 "world") (list 6 'no-evt)))
