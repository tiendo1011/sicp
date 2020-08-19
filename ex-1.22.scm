(load "prime?.scm")

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (search-for-primes start end count)
  (cond ((> count 2) (display "found 3 primes"))
        ((> start end) (display "end of sequence"))
        ((prime? start) (display start) (display "\n") (search-for-primes (+ start 2) end (+ count 1)))
        ((search-for-primes (+ start 2) end count))))

; (search-for-primes 1001 9999 0)
; (search-for-primes 10001 99999 0)
; (search-for-primes 100001 999999 0)
; (search-for-primes 1000001 9999999 0)
(timed-prime-test 1009) ; Some how warm up time takes a huge portion, this to design away that problem
; (timed-prime-test 1009)
; (timed-prime-test 10007)
; Time from 2 -> 4

; (timed-prime-test 100003)
; (timed-prime-test 1000003)
; Time from 9 -> 27
; Conclusion: it's compatable
