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
    (define mat (list-ref m-or-qa-or-i from))  ; |mono| * 3
    (deinf next (list-ref mat from))  ; |mono| * (|mono| + |qa| + |list|)

    ; (define next (list-ref trans-mat from))

    ; (model
    ;   'read
    ;   )
    ; )
  )


