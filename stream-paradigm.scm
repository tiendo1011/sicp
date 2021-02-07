(load "stream.scm")

(define (average x y)
  (/ (+ x y) 2))

(define (sqrt-improve guess x)
  (average guess (/ x guess)))

(define (sqrt-stream x)
  (define guesses
    (cons-stream
      1.0
      (stream-map (lambda (guess) (sqrt-improve guess x))
                  guesses)))
  guesses)

(define (pi-summands n)
  (cons-stream (/ 1.0 n)
               (stream-map - (pi-summands (+ n 2)))))

(define pi-stream
  (scale-stream (partial-sums (pi-summands 1)) 4))

(define (euler-transform s)
  (let ((s0 (stream-ref s 0))
        (s1 (stream-ref s 1))
        (s2 (stream-ref s 2)))
       (cons-stream (- s2 (/ (square (- s2 s1))
                             (+ s0 (* -2 s1) s2)))
                    (euler-transform (stream-cdr s)))))

(define (make-tableau transform s)
  (cons-stream s (make-tableau transform (transform s))))

(define (accelerated-sequence transform s)
  (stream-map stream-car (make-tableau transform s)))

; (stream-filter
;   (lambda (pair) (prime? (+ (car pair) (cadr pair))))
;   int-pairs)

(define (pairs s t)
  (cons-stream
    (list (stream-car s) (stream-car t))
    (interleave
      (stream-map (lambda (x) (list (stream-car s) x))
                  (stream-cdr t))
      (pairs (stream-cdr s) (stream-cdr t)))))

(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (interleave s2 (stream-cdr s1)))))

(define (merge-weighted s1 s2 weight)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
          (let ((s1car (stream-car s1))
                (s2car (stream-car s2)))
               (cond ((< (weight s1car) (weight s2car))
                      (cons-stream
                        s1car
                        (merge-weighted (stream-cdr s1) s2 weight)))
                     ((> (weight s1car) (weight s2car))
                      (cons-stream
                        s2car
                        (merge-weighted s1 (stream-cdr s2) weight)))
                     (else
                       (cons-stream
                         s1car
                         (merge-weighted (stream-cdr s1)
                                s2 weight))))))))

(define (weighted-pairs s t weight)
  (cons-stream
    (list (stream-car s) (stream-car t))
    (merge-weighted
      (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
      (weighted-pairs (stream-cdr s) (stream-cdr t) weight)
      weight)))

(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream
      initial-value
      (let ((integrand (force delayed-integrand)))
           (add-streams (scale-stream integrand dt) int))))
  int)

; This proc from the book:
; (define (solve f y0 dt)
;   (define y (integral (delay dy) y0 dt))
;   (define dy (stream-map f y))
;   y)

; yield error: y: undefined; cannot use before initialization
; So I need to use another proc copied from the internet
; so that I can run it here
; Ref: https://github.com/sicp-lang/sicp/issues/28
(define (solve f y0 dt)
  (define y (integral (delay (force dy)) y0 dt))
  (define dy (delay (stream-map f y)))
  y)

(stream-ref (solve (lambda (y) y)
                   1
                   0.001)
            1000)
