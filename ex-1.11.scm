; 1. Recursive process
; (define (f n)
;   (if (< n 3) n (+ (f (- n 1)) (* 2 (f (- n 2))) (* 3 (f (- n 3))))))

; (f 3) = 4
; (f 4) = 11
; (f 5) = 25

; 2. Iteractive process
(define (new-f a b c) (+ a (* 2 b) (* 3 c)))

(define (f-iter f-counter f-counter-1 f-counter-2 counter n)
  (if (> counter n)
    f-counter
    (f-iter (new-f f-counter f-counter-1 f-counter-2) f-counter f-counter-1 (+ counter 1) n)))

(define (f n)
  (cond ((< n 3) n)
        (else (f-iter 2 1 0 3 n))))

; (f 3) = 4
; (f 4) = 11
; (f 5) = 25
