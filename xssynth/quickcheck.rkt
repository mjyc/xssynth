#lang racket

(require quickcheck racket/promise)

(define string->number-returns-number
    (property ([str arbitrary-string])
      (number? (string->number str))))

(quickcheck string->number-returns-number)


(define test
    (property ([lst (arbitrary-list arbitrary-integer)])
      (displayln lst)
      #t))

(define test2
    (property ([lst (arbitrary-list (arbitrary (choose-mixed (list (delay (choose-integer 1 10)) (delay (choose-integer 20 30))) ) (lambda (x gen) gen)))])
      (displayln lst)
      #t))

(define test3
    (property ([lst (arbitrary-list (arbitrary-mixed (list   (cons '() arbitrary-integer)   (cons '() arbitrary-boolean)   )))])
      (displayln lst)
      #t))


(struct empty-event () #:transparent)

(define generator-empty-event
  (generator (lambda (i rgen) (empty-event))))

(define arbitrary-empty-event
  (arbitrary generator-empty-event
             (lambda (x gen) gen)
             ))

; (define arbitrary-integer-boolean-empty-event
;     (arbitrary-mixed (list (cons '() arbitrary-integer)
;                            (cons '() arbitrary-boolean)
;                            (cons '() arbitrary-empty-event)
;                            )))

(define arbitrary-integer-boolean-empty-event
    (arbitrary-mixed (list (cons '() arbitrary-integer)
                           (cons '() arbitrary-boolean)
                           (cons '() arbitrary-empty-event)
                           )))

(define (arbitrary-streams n)
  (arbitrary-list
    (apply arbitrary-tuple
      (build-list n (lambda (x) arbitrary-integer-boolean-empty-event)))))
  ; (arbitrary-list (arbitrary-tuple arbitrary-integer-boolean-empty-event
  ;                                  arbitrary-integer-boolean-empty-event)))

(define test4
    (property ([lst (arbitrary-streams 3)])
      (define a (for/list ([i (range 3)])
        (map (lambda (x) (list-ref x i)) lst)))
      (printf "~a~%~%" a)
      ; generate a function that ...
      ; (printf "1: ~a~%2: ~a~%~%" (map car lst) (map (lambda (x) (list-ref x 1)) lst))
      #t))

(quickcheck test4)

