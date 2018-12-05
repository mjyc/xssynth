#lang rosette

(require
  "lang2.rkt"
  rosette/lib/synthax
  rosette/lib/angelic
  )

(provide (all-defined-out))


(define (??text2say-index texts)
  (apply choose* (build-list (length texts) identity)))

(define trans-tbl
        (build-list (length sentences)
          (lambda (x)
            (choose*
              (cons 'monologue (??text2say-index sentences))
              ))))

(define (??transition sentences in m)
  (printf "m ~a in ~a~%" m in)
  (cond
    ; Monologue pattern
    [(and (equal? (model-state m) 'monologue)
          (equal? (input-type in) 'speechsynth-done))

      ; (define trans-tbl
      ;   (build-list (length sentences)
      ;     (lambda (x)
      ;       (cons 'monologue (choose* 0 1 2))
      ;       )))
      ; (define trans-tbl
      ;   (list
      ;     (cons 'monologue (choose 0 1 2))
      ;     (cons 'monologue (choose 0 1 2))
      ;     (cons 'monologue (choose 0 1 2))
      ;     ))
      ; (define trans-tbl
      ;   (list (cons 'monologue 1) (cons 'monologue 2) (cons 'monologue 0)))
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
