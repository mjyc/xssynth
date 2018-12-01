#lang rosette

(require
  rosette/lib/lift
  (prefix-in racket/ (only-in racket in-range in-indexed))
  )

(provide (all-defined-out))

(define-lift in-range
  [(number? number?) racket/in-range])

(define-lift in-indexed
  [(list?) racket/in-indexed])
