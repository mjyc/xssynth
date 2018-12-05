#lang rosette

(require
  "lang.rkt"
  "lang2.rkt"
  "hole2.rkt"
  rosette/lib/synthax
  rosette/lib/angelic
  )

(define sentences
  (list "Hello" "world" "Yay!"))

(define (transition in m)
  (printf "m ~a in ~a~%" m in)
  (cond
    [(and (equal? (model-state m) 'monologue)
          (equal? (input-type in) 'speechsynth-done))
      (define trans-tbl
        (list (cons 'monologue 1) (cons 'monologue 2) (cons 'monologue 0)))
      (define prev-state (model-state m))
      (define prev-text2say-index (variables-text2say-index (model-variables m)))
      (define state (car (list-ref trans-tbl prev-text2say-index)))
      (define text2say-index (cdr (list-ref trans-tbl prev-text2say-index)))
      (define text2say (list-ref sentences text2say-index))
      (model state (variables text2say-index) (create-outputs text2say))
      ]
    [else
      (printf "Undefined transition: m ~a in ~a~%" m in)
      m]))

(define numinputs 1)
(define inputsize 4)

(define test-inputs
  (list
    (list
      (input 'speechsynth-done '())
      (input 'speechsynth-done '())
      (input 'speechsynth-done '())
      (input 'speechsynth-done '())
      )
    )
  )

; (define (t in m) (??transition sentences in m))
(define prog
  (program
    numinputs
    (list
      (xsfold (r 0) transition (model 'monologue (variables 0) (create-outputs)))
      )))

(displayln "Program evaluation:")
(program-interpret prog test-inputs)



(define sym-inputs
  (list
    (for/list ([i inputsize])
      (choose* (input 'speechsynth-done '()) '()))
    ))

(displayln "")
(displayln "")
(define (t in m) (??transition sentences in m))
(define M
  (synthesize
    #:forall (symbolics sym-inputs)
    #:guarantee (assert (equal?
      (program-interpret prog sym-inputs)
      (program-interpret (program
        numinputs
        (list
          (xsfold (r 0) t (model 'monologue  (variables 0) (create-outputs)))
          )) sym-inputs)
      )))
  )

(printf "~%Program synthesis:~%")
(if (sat? M)
  ; M ; (print-forms M)
  (evaluate trans-tbl M)
  (displayln "No program found"))
