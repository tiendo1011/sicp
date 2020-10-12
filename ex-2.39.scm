(define (reverse sequence)
  (fold-right (lambda (x y) (append y (list x))) nil sequence))

(reverse (list 1))
(reverse (list 1 2 3))

(define (reverse sequence)
  (fold-left (lambda (x y) (append (list y) x)) nil sequence))

(reverse (list 1))
(reverse (list 1 2 3))
