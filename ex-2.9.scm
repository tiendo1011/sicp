(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (sub-interval x y)
  (add-interval
    x
    (make-interval (- (upper-bound y))
                   (- (lower-bound y)))))

; To simplify things, we'll use normal +/-,
; And use these abbr conventions:
; lower-bound x -> low-x
; upper-bound x -> up-x
; combined width of add-interval
; = ((up-x + up-y) - (low-x + low-y)) / 2
; = ((up-x - low-x) + (up-y - low-y)) / 2
; = (width-x * 2 + width-y * 2) / 2
; = width-x + width-y

; combined width of sub-interval
; lower-bound = + (lower-bound x) (- (upper-bound y)) = low-x - up-y
; upper-bound = + (upper-bound x) (- (lower-bound y)) = up-x - low-y
; combined-width
; = (up-x - low-y) - (low-x - up-y) / 2
; = ((up-x - low-x) + (up-y - low-y)) / 2
; = (width-x * 2 + width-y * 2) / 2
; = width-x + width-y

(define (mul-interval x y)
  let  (p1 (* (lower-bound x) (lower-bound y)))
  (p2 (* (lower-bound x) (upper-bound y)))
  (p3 (* (upper-bound x) (lower-bound y)))
  (p4 (* (upper-bound x) (upper-bound y)))
  (make-interval (min p1 p2 p3 p4)
                 (max p1 p2 p3 p4)))

; combined width of mul-interval:
; ((max p1 p2 p3 p4) - (min p1 p2 p3 p4)) / 2
; Let's assume up-x, up-y, low-x, low-y are all non-negative integers
; ((up-x * up-y) - (low-x * low-y)) / 2
; The upper doesn't seem to have any relation with
; = ((up-x - low-x) + (up-y - low-y)) / 2

(define (div-interval x y)
  (mul-interval
    x
    (make-interval (/ 1.0 (upper-bound y))
                   (/ 1.0 (lower-bound y)))))
; combined width of div-interval:
; ((up-x / low-y) - (low-x / up-y)) / 2
; (up-x * up-y - low-x * low-y) / (2 * (low-y * up-y))
; combined-width-of-mul-interval / (low-y * up-y)
; The upper doesn't seem to have any relation with
; = ((up-x - low-x) + (up-y - low-y)) / 2
