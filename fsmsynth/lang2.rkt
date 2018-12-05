#lang rosette/safe

(require "lang.rkt")

(provide (all-defined-out))


(struct model (state variables outputs) #:transparent)
(struct variables (text2say-index) #:transparent)
(struct outputs (speechsynth
                 speechrecog
                 audioplayer
                 facialexpression) #:transparent)
(struct input (type value) #:transparent)

; (define (create-variables [monologue-index -1]
;                           [question-index -1]
;                           [answer-index -1]
;                           [instruction-index -1])
;   (outputs speechsynth speechrecog audioplayer facialexpression))

(define (create-outputs [speechsynth '()]
                        [speechrecog '()]
                        [audioplayer '()]
                        [facialexpression '()])
  (outputs speechsynth speechrecog audioplayer facialexpression))
(define (create-input type [value #f])
  (input type value))


(define states
  (list 'monologue 'question 'answer))

(define input-types
  (list 'speechsynth-done))

(define sentences
  (list "Hello" "world" "Yay!"))
