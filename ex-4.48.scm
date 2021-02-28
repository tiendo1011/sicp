; Let's see if I can add adjectives
; Maybe trying to parse: "the professor lectures to the student in a huge class"

; What's the problem?
; In simple case, parse noun-phrase
; will either return a noun phrase, or hit the require & fail, which signal
; the evaluator to try again with other option of the nearest amb
; In case of adjective, it requires the ability to distinguish a noun phrase
; with adjective & a noun phrase without one, in one go
; We can use amb for that

(load "metacircular-evaluator-amb-evaluation.scm")
(driver-loop)
(define (require p) (if (not p) (amb)))

(define nouns '(noun student professor cat class))
(define verbs '(verb studies lectures eats sleeps))
(define articles '(article the a))
(define prepositions '(prep for to in by with))
(define adjectives '(adjective huge smart)) ; I forgot to add adjective at the beginning of the list, which causes the solution
                                            ; to fail, and causes a huge pain figure it out
                                            ; The lesson?
                                            ; Be extremely careful when categorizing things
                                            ; and don't let your emotion fools you

(define (memq val a-list)
  (cond ((null? a-list) false)
        ((equal? (car a-list) val) true)
        (else (memq val (cdr a-list)))))

(define (parse-word word-list)
  (require (not (null? *unparsed*)))
  (require (memq (car *unparsed*) (cdr word-list)))
  (let ((found-word (car *unparsed*)))
       (set! *unparsed* (cdr *unparsed*))
       (list (car word-list) found-word)))

(define *unparsed* '())

(define (parse input)
  (set! *unparsed* input)
  (let ((sent (parse-sentence)))
       (require (null? *unparsed*)) sent))

(define (parse-prepositional-phrase)
  (list 'prep-phrase
        (parse-word prepositions)
        (parse-noun-phrase)))

(define (parse-sentence)
  (list 'sentence (parse-noun-phrase) (parse-verb-phrase)))

(define (parse-verb-phrase)
  (define (maybe-extend verb-phrase)
    (amb verb-phrase
         (maybe-extend
           (list 'verb-phrase
                 verb-phrase
                 (parse-prepositional-phrase)))))
  (maybe-extend (parse-word verbs)))

; (define (parse-simple-noun-phrase)
;   (list 'simple-noun-phrase
;         (parse-word articles)
;         (parse-word nouns)))

; (define (parse-simple-noun-phrase)
;   (list 'simple-noun-phrase
;         (parse-word articles)
;         (parse-word adjectives)
;         (parse-word nouns)))

(define (parse-simple-noun-phrase)
  (let ((article (parse-word articles)))
       (amb
         (list 'simple-noun-phrase
               article
               (parse-word nouns))
         (list 'simple-noun-phrase
               article
               (parse-word adjectives)
               (parse-word nouns)))))

(define (parse-noun-phrase)
  (define (maybe-extend noun-phrase)
    (amb noun-phrase
         (maybe-extend
           (list 'noun-phrase
                 noun-phrase
                 (parse-prepositional-phrase)))))
  (maybe-extend (parse-simple-noun-phrase)))

(parse '(the professor lectures to the student in a huge class))
