(define zero (lambda (f) (lambda (x) x)))
(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

; Define one by evaluating (add-1 zero)
(add-1 zero)
(add-1 (lambda (f) (lambda (x) x)))
(lambda (f) (lambda (x) (f (((lambda (f) (lambda (x) x)) f) x))))
(lambda (f) (lambda (x) (f ((lambda (x) x) x))))
(lambda (f) (lambda (x) (f x)))
(define one (lambda (f) (lambda (x) (f x))))

; Define two by evaluating (add-1 one)
(add-1 one)
(add-1 (lambda (f) (lambda (x) (f x))))
(lambda (f) (lambda (x) (f (((lambda (f) (lambda (x) (f x))) f) x))))
(lambda (f) (lambda (x) (f ((lambda (x) (f x)) x))))
(lambda (f) (lambda (x) (f (f x))))
(define two (lambda (f) (lambda (x) (f (f x)))))

; + procedure
(define zero (lambda (f) (lambda (x) x)))
(define two  (lambda (f) (lambda (x) (f (f x)))))
(define (+ a b)
  (lambda (f) (lambda (x) ((a f) ((b f) x)))))

; Test case 1: (+ zero two)
(lambda (f) (lambda (x) ((a f) ((lambda (f) (lambda (x) (f (f x))) f) x))))
(lambda (f) (lambda (x) ((a f) ((lambda (x) (f (f x))) x))))
(lambda (f) (lambda (x) ((a f) (f (f x)))))
(lambda (f) (lambda (x) ((lambda (f) (lambda (x) x) f) (f (f x)))))
(lambda (f) (lambda (x) ((lambda (x) x) (f (f x)))))
(lambda (f) (lambda (x) (f (f x)))) ; <= This is the direct definition of two
; Test case 2: (+ two zero)
(lambda (f) (lambda (x) ((a f) ((lambda (f) (lambda (x) x) f) x)))))
(lambda (f) (lambda (x) ((a f) x)))
(lambda (f) (lambda (x) ((lambda (f) (lambda (x) (f (f x))) f) x)))
(lambda (f) (lambda (x) ((lambda (x) (f (f x))) x)))
(lambda (f) (lambda (x) (f (f x)))) ; <= This is the direct definition of two
