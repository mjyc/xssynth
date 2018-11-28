#lang rosette

(require rackunit
         "lang.rkt")

(define standard-stream (list 1 2 3))


(define empty-evt-stream '())
(define stream-with-no-evts (list (list 1 'no-evt) (list 2 "hello") (list 5 "world") (list 6 'no-evt)))
