; What in fact was the order in which the five girls were placed?
; there are 5 places & 5 girls, so we have about 120 combinations
; How do we filter them?
; Using their statements
; The problem is, only half of their statements are true
; What is the consequence of the untrue statements?
; Follow them would not lead to a sensable result
; So we can use that
; We follow them until there is one that lead to a sensible result

(define (liars)
  (let ((betty (amb 3 1))
        (ethel (amb 1 5))
        (joan (amb 3 2))
        (kitty (amb 2))
        (mary (amb 4)))
       (require
         (distinct? (list betty ethel joan kitty mary)))
       (list (list 'betty betty)
             (list 'ethel ethel)
             (list 'joan joan)
             (list 'kitty kitty)
             (list 'mary mary))))
(liars)
; ((betty 1) (ethel 5) (joan 3) (kitty 2) (mary 4))
