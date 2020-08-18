(define (remainder a b)
  (if (< a b)
      a
      (remainder (- a b) b)))

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

; ============ Normal-order evaluation ===========
(gcd 206 40)
; ============ Normal-order evaluation ===========

; Round 1
(if (= 40 0)
      206
      (gcd 40 (remainder 206 40)))
; total remainder called 0 time
; end of Round 1 value:
(gcd 40 (remainder 206 40))

; Round 2
if (= (remainder 206 40) 0)
    40
    (gcd (remainder 206 40) (remainder 40 (remainder 206 40)))
; total remainder called 1 time,
; end of Round 2 value:
(gcd (remainder 206 40) (remainder 40 (remainder 206 40)))

; Round 3
(if (= (remainder 40 (remainder 206 40)) 0)
      (remainder 206 40)
      (gcd (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))
; total remainder called 3 time
; end of round 3 value:
(gcd (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))

; Round 4
(if (= (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) 0)
      (remainder 40 (remainder 206 40))
      (gcd (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))))
; total remainder called 7 times
; End of round 4 value:
(gcd (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))

; Round 5
(if (= (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))) 0)
      (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))
      (gcd (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))) (remainder (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))))
; total remainder called 14 times
; end of round 5 value:
(remainder (remainder 206 40) (remainder 40 (remainder 206 40)))

; Round 6
; => Total remainder called 18 times

 ; ============== Applicative-order evaluation =============
(gcd 206 40)
; ============== Applicative-order evaluation =============

(if (= b 0)
      a
      (gcd b (remainder a b)))

; Round 1
(if (= 40 0)
      206
      (gcd 40 (remainder 206 40)))
; Tocal remainder called 1 time
; end of round 1 value:
(gcd 40 6)

; Round 2
(if (= 6 0)
      40
      (gcd 6 (remainder 40 6)))
; Total remainder called 2 times
; end of round 2 value:
(gcd 6 4)

; Round 3
(if (= 4 0)
      6
      (gcd 4 (remainder 6 4)))
; Total remainder called 3 times
; end of round 3 value:
(gcd 4 2)

; Round 4
(if (= 2 0)
      4
      (gcd 2 (remainder 4 2)))
; Total remainder called 4 times
; end of round 4 value:
(gcd 2 0)

; Round 5
(if (= 0 0)
      2
      (gcd b (remainder a b)))
2
