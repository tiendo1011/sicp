(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
           (append rest (map (lambda (l) (cons (car s) l)) rest)))))

(length (subsets (list 1 2 3)))

; Why it works
; subsets s = set that has (car s) + set that doesn't have (car s)
; (map to add (car s) to (set that doesn't have (car s)) + (set that doesn't have (car s))
