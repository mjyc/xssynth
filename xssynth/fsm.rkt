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
    [(and (eqv? s 'init) (equal? in 'c)) 'more]
    [(and (equal? s 'more) (equal? in 'a)) 'more]
    [(and (equal? s 'more) (equal? in 'd)) 'more]
    [(and (equal? s 'more) (equal? in 'r)) 'complete]
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
    [(and (equal? s 'init) (equal? in 'c)) 'more]
    [(and (equal? s 'more) (equal? in 'a)) (choose 'init 'more)]
    [(and (equal? s 'more) (equal? in 'd)) (choose 'init 'more)]
    [(and (equal? s 'more) (equal? in 'r)) 'complete]
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
      (program-interpret prog sym-inputs)
      (program-interpret sketch sym-inputs)
      ))))

(printf "~%Program synthesis:~%")
(if (sat? M)
  (print-forms M)  ; (evaluate sketch M)
  (displayln "No program found"))
