#lang rosette

(require rosette/lib/angelic)

(define sentences (list "hello" "world!"))

; TODO: create these:
; (define (??trans-mat)
;   (for/list ([i n])
;     (apply choose* (build-list n identity)))
;   )
; ...

; TODO: and this:
; (define (??monologue sentences)
; ;Q do I need condition here?
;   (define n (length sentences))

;   (define mat (choose m-trmat qa-trmat i-trmat))
;   (list-ref mat )
;   )

; (and (equal? (model-state m) 'read) (equal? (input-type in) 'read-done))

(define (??sentence-index sentences)
  (build-list (length sentences) identity))

(define (??sentence-index questions answers)
  (build-list (sum (length questions) (length answers)) identity))


(define (??transition sentences)

  (printf "m ~a in ~a~%" m in)
  (cond
    [(and (equal? (model-state m) 'monologue) (equal? (input-type in) 'speechsynth-done))
      (define (trans-tbl)
        (build-list (length sentences)
          (lambda (x)
            (choose*
              (list 'monologue (??sentence-index sentences))
              (list 'question (??question-index questions))
              (list 'instruction (??instruction-index instructions))
              ))))

      (define prev-sentence-index (model-variables sentence-index))
      (define state (first (list-ref trans-tbl cur-sentence-index)))
      (define sentence-index (first (list-ref trans-tbl cur-sentence-index)))

      (cond
        [(equal state 'monologue)
          ()] ; create model
        [(equal state 'question)
          ()]
        [(equal state 'instruction)
          ()]
        )
      (model
        (create-outputs
          (list-ref sentences sentence-index)  ; sentence
          )
        )
      ]

    [(and (equal? (model-state m) 'question) (equal? (input-type in) 'speechsynth-done))

      (define (trans-tbl)
        (build-list (length sentences)
          (lambda (x)
            (choose*
              (list 'answer (??sentence-index sentences))  ; Q: do I need question index?
              ))))

      (define prev-question-index (model-variables sentence-index))
      (define state 'answer)
      (define sentence-index (first (list-ref trans-tbl cur-sentence-index)))

      ; answer "text" should be a variable
      (model
        (create-outputs
          (list-ref sentences sentence-index)  ; sentence
          )
        )

      ]

    [(and (equal? (model-state m) 'question) (equal? (input-type in) 'speechsynth-done))

      ; go anywhere

      (model
        '
        (create-outputs
          (list-ref sentences sentence-index)  ; sentence
          )
        )

      ]

    [(and (equal? (model-state m) 'instruction) (equal? (input-type in) 'speechsynth-done))
      ; start monitoring
      ]

    [(and (equal? (model-state m) 'instruction) (equal? (input-type in) 'monitor-done))
      ; transition to a new place
      ]

    ; [(and (equal? (model-state m) 'instruction) (equal? (input-type in) 'monitor-done))

    ; ]
  )


(define (??monologue sentences)

  (define (trans-mat)
    (build-list (length sentences)
      (lambda (x)
        (choose*
          (??sentence-index sentences)
          (??question-index questions)
          (??answer-index answers)
          (??instruction-index instructions)
          ))))



  (model 'mono
    variables
    vars
    outs))

(define (??monologue vars outs)
  (model 'mono
    variables
    vars
    outs))

(define (??question-answer vars outs)
  (model 'qa vars outs))

(define (??instruction vars outs)
  (model 'inst vars outs))




(define (??monologue1 m)
  (model
    'monologue
    (variables
      (variables-sentences-index m)
      (variables-sentences-index m)
      )
    )
  )

(define (??monologue0 sentences)
  ; (define (f m)
  ;   ()
  ;   )
  ; f)
  (lambda (m)
    (define n (length sentences))
    (define trans-mat
      (build-list (sub1 n) (lambda (x) (sub1 x))))

    (define from (variables-monologue-index (model-variables m)))
    ; select variable
    (define mat (list-ref m-or-qa-or-i from))  ; |mono| * 3
    ; select next-index
    (deinf next (list-ref mat from))  ; |mono| * (|mono| + |qa| + |list|)

    ; (define next (list-ref trans-mat from))
    ; (model
    ;   'read
    ;   )
    ; )
  )


