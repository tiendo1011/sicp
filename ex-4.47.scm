(define (parse-verb-phrase)
  (define (maybe-extend verb-phrase)
    (amb verb-phrase
         (maybe-extend
           (list 'verb-phrase
                 verb-phrase
                 (parse-prepositional-phrase)))))
  (maybe-extend (parse-word verbs)))

; Louis proposal
(define (parse-verb-phrase)
  (amb (parse-word verbs)
       (list 'verb-phrase
             (parse-verb-phrase)
             (parse-prepositional-phrase))))

; Does this work?
; How do I know if it works?
; Let's see how it parses a sentence
; "The professor lectures to the student with the cat"
; After parsing lectures in (parse-word verbs)
; amb choose the next option (list 'verb-phrase (parse-verb-phrase) (parse-prepositional-phrase))
; which execute (parse-verb-phrase)
; which in turn calls (amb (parse-word verbs))
; which fails => this doesn't work

; the original procedure doesn't calls parse-verb-phrase again so it works

; change the order would make the program becomes an infinate loop
