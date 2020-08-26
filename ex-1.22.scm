(load "prime?.scm")
(load "report-elapsed-time.scm")

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)
      (report-elapsed-time start-time)))

(define (search-for-primes start end count)
  (cond ((> count 2) (display "found 3 primes"))
        ((> start end) (display "end of sequence"))
        ((prime? start) (display start) (display "\n") (search-for-primes (+ start 2) end (+ count 1)))
        ((search-for-primes (+ start 2) end count))))

(search-for-primes 1001 9999 0) ; 1009 1013 1019
(search-for-primes 10001 99999 0) ; 10007 10009 10037
(search-for-primes 100001 999999 0) ; 100003 100019 100043
(search-for-primes 1000001 9999999 0) ; 1000003 1000033 1000037
(timed-prime-test 1009) ; Some how warm up time takes a huge portion, this to design away that problem

(timed-prime-test 1009) ; smallest-divisor: 19, smallest-divisor-improved: 13
(timed-prime-test 1013) ; smallest-divisor: 19, smallest-divisor-improved: 12
(timed-prime-test 1019) ; smallest-divisor: 20, smallest-divisor-improved: 13
(timed-prime-test 10007) ; smallest-divisor: 236, smallest-divisor-improved: 162
(timed-prime-test 10009) ; smallest-divisor: 236, smallest-divisor-improved: 157
(timed-prime-test 10037) ; smallest-divisor: 236, smallest-divisor-improved: 172
(timed-prime-test 100003) ; smallest-divisor: 3014, smallest-divisor-improved: 1752
(timed-prime-test 100019) ; smallest-divisor: 3007, smallest-divisor-improved: 1715
(timed-prime-test 100043) ; smallest-divisor: 3007, smallest-divisor-improved: 1743
(timed-prime-test 1000003) ; smallest-divisor: 36487, smallest-divisor-improved: 20280
(timed-prime-test 1000033) ; smallest-divisor: 36406, smallest-divisor-improved: 20474
(timed-prime-test 1000037) ; smallest-divisor: 36509, smallest-divisor-improved: 20542
