#lang rosette

(require rosette/lib/synthax)

(provide (all-defined-out))


; Streams

(define NOEVENT 'no-evt)

(define (empty-event? e)
  (eq? NOEVENT e))

(define (not-empty-event? e)
  (not (eq? NOEVENT e)))

; Behavior (MemoryStream)

(struct behavior (init changes) #:transparent)

(define (new-behavior constructor n)
  (behavior (constructor) (for/list ([i n]) (constructor))))


; Helpers

(define (get-sym-bool)
  (define-symbolic* b boolean?) b)

(define (new-event-stream constructor n)
  (for/list ([i n])
    (if (get-sym-bool) (constructor) NOEVENT)))
