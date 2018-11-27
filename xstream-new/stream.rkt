#lang rosette

(require rosette/lib/synthax)

(provide (all-defined-out))


; Streams

(define NOEVENT 'no-evt)

(define (empty-event? e)
  (eq? NOEVENT e))

(define (not-empty-event? e)
  (not (eq? NOEVENT e)))


; Helpers

(define (get-sym-bool)
  (define-symbolic* b boolean?) b)

(define (new-event-stream constructor n)
  (for/list ([i n])
    (if (get-sym-bool) (constructor) NOEVENT)))
