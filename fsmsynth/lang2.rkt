#lang rosette/safe

(require "lang.rkt")

(struct model (state variables outputs) #:transparent)
(struct variables (monologue-index
                   question-index
                   answer-index
                   instruction-index) #:transparent)
(struct outputs (speechsynth
                 speechrecog
                 audioplayer
                 facialexpression) #:transparent)
(struct input (type value) #:transparent)

(define (create-variables [monologue-index -1]
                          [question-index -1]
                          [answer-index -1]
                          [instruction-index -1])
  (outputs speechsynth speechrecog audioplayer facialexpression))

(define (create-outputs [speechsynth '()]
                        [speechrecog '()]
                        [audioplayer '()]
                        [facialexpression '()])
  (outputs speechsynth speechrecog audioplayer facialexpression))
(define (create-input type [value #f])
  (input type value))
