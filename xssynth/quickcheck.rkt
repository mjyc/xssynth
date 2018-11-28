#lang racket

(require quickcheck racket/promise)

(define string->number-returns-number
    (property ([str arbitrary-string])
      (number? (string->number str))))

(quickcheck string->number-returns-number)


(define test
    (property ([lst (arbitrary-list arbitrary-integer)])
      (displayln lst)
      true))

(define test2
    (property ([lst (arbitrary-list (arbitrary (choose-mixed (list (delay (choose-integer 1 10)) (delay (choose-integer 20 30))) ) (lambda (x gen) gen)))])
      (displayln lst)
      true))

(define test3
    (property ([lst (arbitrary-list (arbitrary-mixed (list   (cons '() arbitrary-integer)   (cons '() arbitrary-boolean)   )))])
      (displayln lst)
      true))


(quickcheck test3)
