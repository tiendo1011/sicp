(define (count-pairs x)
  (if (not (pair? x))
      0
      (+ (count-pairs (car x))
         (count-pairs (cdr x))
         1)))

(define l1 (cons 'a (cons 'b (cons 'c '()))))
(count-pairs l1) ; 3

(define c (list 'c))
(define l2 (cons 'a (cons c c)))
(count-pairs l2) ; 4

(define c (list 'c))
(define b (cons c c))
(define l3 (cons b b))
(count-pairs l3) ; 7

; Never return at all
; (define (make-cycle x)
;   (set-cdr! (last-pair x) x)
;   x)

; (make-cycle (list 'a 'b 'c))
