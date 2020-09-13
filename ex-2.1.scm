(define (make-rat n d)
  (let ((g (gcd n d)))
    (if (< d 0)
        (cons (* (/ n g) -1) (* (/ d g) -1))
        (cons (/ n g) (/ d g)))))

(define (numer x) (car x))
(define (denom x) (cdr x))

(define (print-rat x)
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))

(define x (make-rat 6 -9))
(define y (make-rat -6 -9))
(print-rat x)
(print-rat y)
