#lang rosette

(require
  "lang.rkt"
  "hole.rkt"
  rosette/lib/synthax
  rosette/lib/angelic
  )


(define inputsize 4)
(define numinputs 1)

(define test-inputs
  (list
    (list 'c 'a 'a 'r 'r)
    ))


(define (trans in s)
  ; (printf "in: ~a s: ~a~%" in s)
  (cond
    [(and (eqv? s 'init) (eqv? in 'c)) 'more]
    [(and (eqv? s 'more) (eqv? in 'a)) 'more]
    [(and (eqv? s 'more) (eqv? in 'd)) 'more]
    [(and (eqv? s 'more) (eqv? in 'r)) 'complete]
    [else
      ; (printf "Undefined transition: s ~a in ~a~%" s in)
      s])
  )

(define prog
  (program
    numinputs
    (list
      (xsfold (r 0) trans 'init)
      )))


(displayln "Program evaluation:")
(program-interpret prog test-inputs)


(define sym-inputs
  (list
    (for/list ([i inputsize])
      (choose* 'c 'a 'd 'r))
    ))

(define (??trans in s)
  ; (printf "in: ~a s: ~a~%" in s)
  (cond
    [(and (eqv? s 'init) (eqv? in 'c)) 's1]
    [(and (eqv? s 's1) (eqv? in 'a)) (choose* 's1 's2 'error)]
    [(and (eqv? s 's1) (eqv? in 'd)) (choose* 's1 's2 'error)]
    [(and (eqv? s 's1) (eqv? in 'r)) 'complete]
    [else
      ; (printf "Undefined transition: s ~a in ~a~%" s in)
      s])
  )

(define sketch
  (program
    numinputs
    (list
      (xsfold (r 0) ??trans 'init)
      )))

; (printf "~%Sketch evaluation:~%")
; (program-interpret sketch test-inputs)

sym-inputs
(define M
  (synthesize
    #:forall (symbolics sym-inputs)
    #:guarantee (assert (equal?
      (program-interpret prog sym-inputs) ; doesn't work!
      (program-interpret sketch sym-inputs) ; doesn't work!
      ))))

(printf "~%Program synthesis:~%")
(if (sat? M)
  ; (evaluate sketch M)
  M
  (displayln "No program found"))
