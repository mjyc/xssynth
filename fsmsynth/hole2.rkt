#lang rosette

(require
  "lang2.rkt"
  rosette/lib/synthax
  rosette/lib/angelic
  )

(provide (all-defined-out))

(define (??speech-index speeches)
  (apply choose* (build-list (length speeches) identity)))

(define (??transition-table monologues questions)
  (build-list (length monologues)
    (lambda (x)
      (choose*
        (cons 'monologue (??speech-index monologues))
        (cons 'question (??speech-index questions))
        ; (cons 'instruction (??speech-index instructions))
        ))))

(define (??qa-transition-table questions answers monologues)
  (list  ; Q&A trans-tbl
      (list  ; Q0,
        (cons 'monologue 0)  ; A0
        (cons 'question 1) ; A1
      )
      ; (list  ; Q0,
      ;   (build-list (length answers) (lambda (x)
      ;     (choose*
      ;       (cons 'monologue (??speech-index monologues))
      ;       (cons 'question (??speech-index questions))
      ;       ; (cons 'instruction (??speech-index instructions))
      ;       )))
      ; )
      (list  ; Q1,
        (cons 'monologue 1)  ; A0
        (cons 'monologue 2) ; A1
      )
      )
  ; (build-list (length questions) (lambda (y)
  ;   (build-list (length answers) (lambda (x)
  ;     (choose*
  ;       (cons 'monologue (??speech-index monologues))
  ;       (cons 'question (??speech-index questions))
  ;       ; (cons 'instruction (??speech-index instructions))
  ;       )))))
  )

(define (??transition in m
                      monologue-transition-table
                      question-answer-transition-table
                      [monologues '()]
                      [questions '()]
                      [answers '()]
                      [instructions '()]
                      )
  (printf "m ~a in ~a~%" m in)
  (cond
    ; Monologue pattern
    [(and (equal? (model-state m) 'monologue)
          (equal? (input-type in) 'speechsynth-done))
      (define trans-tbl monologue-transition-table)
      (define prev-speech-index (variables-speech-index (model-variables m)))
      (define state (car (list-ref trans-tbl prev-speech-index)))
      (define speech-index (cdr (list-ref trans-tbl prev-speech-index)))
      (define speech (list-ref monologues speech-index))
      (model state (variables speech-index) (create-outputs speech))
      ]
    ; Question & answer pattern
    [(and (equal? (model-state m) 'question)
          (equal? (input-type in) 'speechsynth-done))
      ; (define trans-tbl question-transition-table)
      ; (define prev-speech-index (variables-speech-index (model-variables m)))
      ; (define state (car (list-ref trans-tbl prev-speech-index)))
      ; (define speech-index (cdr (list-ref trans-tbl prev-speech-index)))
      ; (define speech (list-ref monologues speech-index))
      (model 'answer (model-variables m) (create-outputs '() #t))
      ]
    [(and (equal? (model-state m) 'answer)
          (equal? (input-type in) 'speechrecog-done))
      (define trans-tbl question-answer-transition-table)
      (define prev-speech-index (variables-speech-index (model-variables m)))

      (define cur-input-val-index (index-of answers (input-value in)))
      (define cur (list-ref
        (list-ref trans-tbl prev-speech-index)
        cur-input-val-index
        ))

      (define state (car cur))
      (define speech-index (cdr cur))

      (define speech
        (cond
          [(equal? state 'monologue) (list-ref monologues speech-index)]
          [(equal? state 'question) (list-ref questions speech-index)])
        )
      ; (define speech (list-ref monologues speech-index))
      (model state (variables speech-index) (create-outputs speech))
      ]
    [else
      (printf "Undefined transition: m ~a in ~a~%" m in)
      m]))
