#lang rosette

(require rosette/lib/synthax)
(provide (all-defined-out))


; Event streams are a list of events; each entry in the list represents a single
;   time step an event is a symbolic union over a symbol represents no event and
;   a symbolic value

(define NOEVENT 'no-evt)

(define (empty-event? e)
  (eq? NOEVENT e))

(define (not-empty-event? e)
  (not (eq? NOEVENT e)))

(define (get-sym-bool)
  (define-symbolic* b boolean?) b)

(define (new-event-stream constructor n)
  (for/list ([i n])
    (if (get-sym-bool) (constructor) NOEVENT)))


; Behaviors are a struct containing an initial value and a list of (symbolic)
;   values each entry in the list represents a single timestep no entry in that
;   list can be a non event; behaviors have a value at every timestep

(struct behavior (init changes) #:transparent)

(define (new-behavior constructor n)
  (behavior (constructor) (for/list ([i n]) (constructor))))
