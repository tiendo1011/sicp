; ========== Notes ===========
; When n = 9, the test doesn't return 1 for any a <= n - 1
; Which makes me wonder the validity of the following claim:
; It is also possible to prove that if n is an odd number that is not prime, then,
; for at least half the numbers a < n, computing a^{n - 1} in this way will reveal a
; nontrivial square root of 1 modulo n.
; So I dig deeper and find this answer on StackOverflow:
; https://stackoverflow.com/a/59834347/4632735
; Here is my attempt trying to convert the answer to scheme code
; ============================
(load "square.scm")
(load "display-all.scm")
(load "fast-expt.scm")

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
          (remainder
            (square (expmod base (/ exp 2) m)) ;
            m))
        (else
          (remainder
            (* base (expmod base (- exp 1) m))
            m))))

(define (find-e-k n)
  (define (find-e-k-iter possible-k possible-e)
    (if (= (remainder possible-k 2) 0)
        (find-e-k-iter (/ possible-k 2) (+ possible-e 1))
        (values possible-e possible-k)))
  (find-e-k-iter (- n 1) 0))

; first-witness-case-test: (a ^ k) mod n # 1
(define (first-witness-case-test a k n)
  (not (= (expmod a k n) 1)))

; second-witness-case-test: all a ^ ((2 ^ i) * k) (with i = {0..e-1}) mod n # (n - 1)
(define (second-witness-case-test a e k n)
  (define (second-witness-case-test-iter a i k n)
    (cond ((= i -1) true)
          (else (let ()
                 (define witness (not (= (expmod a (* (fast-expt 2 i) k) n) (- n 1))))
                 (if witness
                 (second-witness-case-test-iter a (- i 1) k n)
                 false)))))
  (second-witness-case-test-iter a (- e 1) k n))

(define (miller-rabin-test n)
  (define (try-it a e k)
    (if (and (first-witness-case-test a k n) (second-witness-case-test a e k n))
        (display-all "is not prime, with a = " a "\n")
        (if (< a (- n 1))
            (try-it (+ a 1) e k)
            (display "is prime\n"))))
  (cond ((< n 2) (display "not prime"))
        ((= (remainder n 2) 0) (display "not prime\n"))
        (else (let ()
               (define-values (e k) (find-e-k n))
               (try-it 1 e k)))))

(miller-rabin-test 5)
(miller-rabin-test 6)
(miller-rabin-test 7)
(miller-rabin-test 9)
(miller-rabin-test 15)
(miller-rabin-test 91)
(miller-rabin-test 97)
(miller-rabin-test 99)
; Carmichael numbers:
(miller-rabin-test 561)
(miller-rabin-test 1105)
(miller-rabin-test 1729)
(miller-rabin-test 2465)
(miller-rabin-test 2821)
(miller-rabin-test 6601)
