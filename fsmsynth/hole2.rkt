#lang rosette

(require
  "lang2.rkt"
  rosette/lib/synthax
  rosette/lib/angelic
  )

(provide (all-defined-out))

-(define (??speech-index speeches)
-  (apply choose* (build-list (length speeches) identity)))

(define (??transition-table monologues)
  (build-list (length monologues)
    (lambda (x)
      (choose*
        (cons 'monologue (??speech-index monologues))
        ; (cons 'question (??speech-index questions))
        ; (cons 'instruction (??speech-index instructions))
        ))))

; (define (??question-transition-table questions answers)
;   (build-list (length questions)
;     (lambda (x)
;       (choose*
;         (cons 'answer (??speech-index answers))
;         ))))

(define (??transition in m
                      monologue-transition-table
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
    [else
      (printf "Undefined transition: m ~a in ~a~%" m in)
      m]))
