(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons (square (car things))
                    answer))))
  (iter items nil))

; Unfortunately, defining square-list this way produces the
; answer list in the reverse order of the one desired. Why?

; Let's try with an example (list 1 2 3 4)
; First iteration:
; cons (square (car things)) answer
; => cons 1 nil
; => (list 1)
; Second iteration:
; cons (square (car things)) answer
; cons (square 2) (list 1)
; (list 4 1)
; And so on

; Louis then tries to fix his bug by interchanging the arguments to cons :
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items nil)
; This doesn’t work either. Explain.
; Let's try with an example (list 1 2 3 4)
; First iteration:
; cons answer (square (car things))
; => cons nil 1
; => (list '() 1)
; Second iteration:
; cons answer (square (car things))
; cons (list '() 1) (square 2)
; (list (list '() 1) 4)
; And so on
; This is not a list by definition
; A list by definition: (cons <a1> (cons <a2> (cons ... (cons <aN> nil)...)))
