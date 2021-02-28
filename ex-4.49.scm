(load "metacircular-evaluator-amb-evaluation.scm")
(driver-loop)
(define (require p) (if (not p) (amb)))

(define nouns '(noun student professor cat class))
(define verbs '(verb studies lectures eats sleeps))
(define articles '(article the a))
(define prepositions '(prep for to in by with))

(define (memq val a-list)
  (cond ((null? a-list) false)
        ((equal? (car a-list) val) true)
        (else (memq val (cdr a-list)))))

; (define (parse-word word-list)
;   (require (not (null? *unparsed*)))
;   (require (memq (car *unparsed*) (cdr word-list)))
;   (let ((found-word (car *unparsed*)))
;        (set! *unparsed* (cdr *unparsed*))
;        (list (car word-list) found-word)))

; The changes is here
; it ignores the “input sentence” and instead always succeeds
; and generates an appropriate word

(define (random a-list)
  (car a-list)) ; to simplify, use car but we can elaborate to do more

(define (parse-word word-list)
  (set! *unparsed* (cdr *unparsed*))
  (list (car word-list) (random (cdr word-list))))

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

(define (parse-simple-noun-phrase)
  (list 'simple-noun-phrase
        (parse-word articles)
        (parse-word nouns)))

(define (parse-noun-phrase)
  (define (maybe-extend noun-phrase)
    (amb noun-phrase
         (maybe-extend
           (list 'noun-phrase
                 noun-phrase
                 (parse-prepositional-phrase)))))
  (maybe-extend (parse-simple-noun-phrase)))

(parse '(the professor lectures to the student))
