; a. Implement letrec as a derived expression
; I'm a bit bored with all these derived expression, so I'll just skip it

; b
; The code if we only use let
(define (f x)
  (let
    ((even? (lambda (n)
                    (if (= n 0) true (odd?  (- n 1)))))
     (odd?  (lambda (n)
                    (if (= n 0) false (even? (- n 1))))))
    ⟨ rest of body of f ⟩ ))

; it's actually is:
(define (f x)
  ((lambda (even? odd?)
           (rest of body of f))
   (lambda (n)
           (if (= n 0) true (odd?  (- n 1))))
   (lambda (n)
           (if (= n 0) false (even? (- n 1))))))

; But odd? in line 19 & event? in side 21 are not defined
