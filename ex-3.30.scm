; half-adder cost: 2 and-gate + 1 or-gate + one inverter
; full-adder cost: 4 add-gate + 3 or-gate + one inverter

(define (full-adder a b c-in sum c-out)
  (let ((s (make-wire)) (c1 (make-wire)) (c2 (make-wire)))
       (half-adder b c-in s c1)
       (half-adder a s sum c2)
       (or-gate c1 c2 c-out)
       'ok))

; ripple-carry-adder pseudocode
; full-adder1 a1 b1 c sum1 c1-out
; wait for c1-out
; full-adder2 a2 b2 c1-out sum2 c2-out
; for-each, run full-adder, which set c-out, use that c-out for next
; loop through ak is easy, but how we get the element from bk sk
; maybe we can build a list from ak, bk, sk, with its element is a list contains a, b, s
(define (zip ak bk sk)
  (if (null? ak)
      '()
      (cons (list (car ak) (car bk) (car sk)) (zip (cdr ak) (cdr bk) (cdr sk)))))

(define (ripple-carry-adder ak bk sk c)
  (let ((wire-compounds (zip ak bk sk)))
       (for-each
         (lambda (wire-compound)
           (full-adder
             (car wire-compound)
             (cadr wire-compound)
             c
             (caddr wire-compound)
             c))
         wire-compounds)))

; delay needed: n * (4 and-gate + 3 or-gate + one inverter)
