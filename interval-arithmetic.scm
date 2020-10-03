(define (make-interval a b) (cons a b))

(define (upper-bound y)
  (if (> (car y) (cdr y))
      (car y)
      (cdr y)))

(define (lower-bound y)
  (if (< (car y) (cdr y))
      (car y)
      (cdr y)))

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (sub-interval x y)
  (add-interval
    x
    (make-interval (- (upper-bound y))
                   (- (lower-bound y)))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
       (p2 (* (lower-bound x) (upper-bound y)))
       (p3 (* (upper-bound x) (lower-bound y)))
       (p4 (* (upper-bound x) (upper-bound y))))
       (make-interval (min p1 p2 p3 p4)
                      (max p1 p2 p3 p4))))

(define (div-interval x y)
  (mul-interval
    x
    (make-interval (/ 1.0 (upper-bound y))
                   (/ 1.0 (lower-bound y)))))

; The formula for parallel resistors
(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1)))
       (div-interval
         one (add-interval (div-interval one r1)
                           (div-interval one r2)))))

; Center-percent-form
(define (make-center-percent c p)
  (let ((width (* (/ p 100) c)))
   (make-interval (- c width) (+ c width))))

(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))

(define (percent i)
  (* (/ (/ (- (upper-bound i) (lower-bound i)) 2) (center i)) 100))
