(load "fast-prime?.scm")

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (fast-prime? n 1)
      (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (search-for-primes start end count)
  (cond ((> count 2) (display "found 3 primes"))
        ((> start end) (display "end of sequence"))
        ((prime? start) (display start) (display "\n") (search-for-primes (+ start 2) end (+ count 1)))
        ((search-for-primes (+ start 2) end count))))

; (search-for-primes 1001 9999 0) ; 1009 1013 1019
; (search-for-primes 10001 99999 0) ; 10007 10009 10037
; (search-for-primes 100001 999999 0) ; 100003 100019 100043
; (search-for-primes 1000001 9999999 0) ; 1000003 1000033 1000037
(timed-prime-test 1009) ; Some how warm up time takes a huge portion, this to design away that problem

(timed-prime-test 1009)
(timed-prime-test 1013)
(timed-prime-test 1019)
(timed-prime-test 10007)
(timed-prime-test 10009)
(timed-prime-test 10037)
(timed-prime-test 100003)
(timed-prime-test 100019)
(timed-prime-test 100043)
(timed-prime-test 1000003)
(timed-prime-test 1000033)
(timed-prime-test 1000037)
