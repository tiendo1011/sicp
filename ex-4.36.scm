; procedure from Ex 4.35:
(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high)))
       (let ((j (an-integer-between i high)))
            (let ((k (an-integer-between j high)))
                 (require (= (+ (* i i) (* j j)) (* k k)))
                 (list i j k)))))

; Explain why simply replacing an-integer-between by an-integer-starting-from
; in the procedure in Exercise 4.35 is not an adequate
; way to generate arbitrary Pythagorean triples.
(define (an-integer-starting-from n)
  (amb n (an-integer-starting-from (+ n 1))))

(define (a-pythagorean-triple-starting-from low)
  (let ((i (an-integer-starting-from low)))
       (let ((j (an-integer-starting-from i)))
            (let ((k (an-integer-starting-from j)))
                 (require (= (+ (* i i) (* j j)) (* k k)))
                 (list i j k)))))

; I guess the problem has to do with how it backtrace
; Since there are no upper bound, it'll only backtrace on k, which will run forever
; To fix this, we need to set the point of backtrace
; Maybe by using an-integer-between for j & k
(define (a-pythagorean-triple-starting-from low)
  (let ((i (an-integer-starting-from low)))
       (let ((j (an-integer-between i (* i 10))))
            (let ((k (an-integer-between j (* j 10))))
                 (require (= (+ (* i i) (* j j)) (* k k)))
                 (list i j k)))))

; With that, when k hit the limit, it'll try the next j
; and when j hit the limit, it'll try the next i
; Although this spark the idea, I couldn't get it to work
; There is a solution here which poses constraint on k & j, which should work:
; https://wizardbook.wordpress.com/2011/01/12/exercise-4-36-2/

