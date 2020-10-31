(define (tree->list-1 tree)
  if (null? tree)
  '()
  (append (tree->list-1 (left-branch tree))
          (cons (entry tree)
                (tree->list-1
                  (right-branch tree)))))

(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list
                              (right-branch tree)
                              result-list)))))
  (copy-to-list tree '()))

; How to know if they can produce the same result for every tree?
; How do they differ?
; The first one seems like a recursive tree process
; The second one seems like a hybrid between linear process & recursive tree process

; The first one calls the procedure itself
; The second one calls its helper procedure, and pass the result-list to it, why?

; The first one moves toward empty list
; The second one moves toward full list

; The first one uses append
; The second one uses copy-to-list
