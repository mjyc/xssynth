#lang rosette/safe


; define state on-the-fly?

(struct model (state variables outputs) #:transparent)

(struct input (name val) #:transparent)

(struct output (speak listen playsnd exprfe) #:transparent)


; (struct speakparam () #:transparent)
; (struct listen () #:transparent)
; (struct playsnd () #:transparent)
; (struct exprfe () #:transparent)

(define (update-sentence variables)

  )


(define (trans m in)
  ; (printf "m ~a in ~a" m in)


  (cond
    [(equal? (model-state m) 'start)
      (model (model-state m) (model-state variables) empty)]

    [(equal? (model-state m) 'read)
      ; update variable
      (model (model-state m) (model-state variables) empty)]

    [(equal? (model-state m) 'read)
      (model (model-state m) (model-state variables) empty)]

    [else
      ; (printf "Undefined transition: s ~a in ~a~%" s in)
      (printf "Undefined transition: m ~a in ~a" m in)
      s])
  )

; write down the list of ...

(model-variable m)

(trans )
