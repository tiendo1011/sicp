(load "metacircular-evaluator-amb-evaluation.scm")
(driver-loop)

(define (square x)
  (* x x))

(define (smallest-divisor n) (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b) (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (require p) (if (not p) (amb)))

(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items))))

(define (prime-sum-pair list1 list2)
  (let ((a (an-element-of list1))
        (b (an-element-of list2)))
       (require (prime? (+ a b)))
       (list a b)))

(let ((pairs '()))
     (if-fail
       (let ((p (prime-sum-pair '(1 3 5 8)
                                '(20 35 110))))
            (permanent-set! pairs (cons p pairs))
            (amb))
       pairs))

; Let's think for a moment, when does if-fail first exp considered failed?
; when it has tried all the options, and couldn't find any acceptable outcome
