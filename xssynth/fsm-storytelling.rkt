#lang rosette

(require
  "lang.rkt"
  "hole.rkt"
  rosette/lib/synthax
  rosette/lib/angelic
  )

(struct model (state variables outputs) #:transparent)
(struct outputs
  (speech-synth
    speech-recog
    audio-player
    facial-expression
    ) #:transparent)

(struct variables (sentence-index) #:transparent)
(struct input (type) #:transparent)

(define states
  (list 'read 'hesitate 'end 'listen 'respond))
(define input-types
  (list 'read-done 'read-done))
(define sentences
  (list "Hello" "world" "Yay!"))

(define (transition in m)
  (printf "m ~a in ~a~%" m in)
  (cond
    [(and (equal? (model-state m) 'read)
          (equal? (input-type in) 'read-done))
      (define cur-sentence-index (add1 (variables-sentence-index (model-variables m))))
      (if (= cur-sentence-index (length sentences))
        (model 'end
          (variables cur-sentence-index)
          (outputs
            '()
            '()
            '()
            '()))
        (model (model-state m)
          (variables cur-sentence-index)
          (outputs
            (list-ref sentences cur-sentence-index)
            '()
            '()
            '()))
        )
      ]

    [else
      (printf "Undefined transition: m ~a in ~a~%" m in)
      m])
  )


(define numinputs 1)
(define inputsize 8)

(define test-inputs
  (list
    (list
      (input 'read-done)
      (input 'read-done)
      (input 'read-done)
      (input 'read-done)
      )
    )
  )

(define prog
  (program
    numinputs
    (list
      (xsfold (r 0) transition (model 'read  (variables -1) (outputs '() '() '() '())))
      )))

(displayln "Program evaluation:")
(program-interpret prog test-inputs)




(define (??transition in m)
  (printf "m ~a in ~a~%" m in)
  (cond
    [(and (equal? (model-state m) 'read)
          (equal? (input-type in) 'read-done))

      ; (define cur-sentence-index (choose -1 0 1 2 3))
      ; (define cur-sentence-index (add1 (variables-sentence-index (model-variables m))))
      (define cur-sentence-index (choose
        (add1 (variables-sentence-index (model-variables m)))
        (sub1 (variables-sentence-index (model-variables m)))
        ))
      (if (= cur-sentence-index (length sentences))
        (model 'end
          (variables cur-sentence-index)
          (outputs
            '()
            '()
            '()
            '()))
        (model (model-state m)
          (variables cur-sentence-index)
          (outputs
            (list-ref sentences cur-sentence-index)
            '()
            '()
            '()))
        )
      ]

    [else
      (printf "Undefined transition: m ~a in ~a~%" m in)
      m])
  )

(define sym-inputs
  (list
    (for/list ([i inputsize])
      (choose* (input 'read-done) '()))
    ))

(displayln "")
(displayln "")
sym-inputs
??transition
(define M
  (synthesize
    #:forall (symbolics sym-inputs)
    #:guarantee (assert (equal?
      (program-interpret prog sym-inputs)
      (program-interpret (program
        numinputs
        (list
          (xsfold (r 0) ??transition (model 'read  (variables -1) (outputs '() '() '() '())))
          )) sym-inputs)
      )))
  )

(printf "~%Program synthesis:~%")
(if (sat? M)
  (print-forms M)  ; (evaluate sketch M)
  (displayln "No program found"))
