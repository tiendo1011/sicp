; Number of set before distinct?
; 5^5 = 3125
; Number of set after distinct?
; 5! = 120
(load "metacircular-evaluator-amb-evaluation.scm")

(driver-loop)

(define (require p) (if (not p) (amb)))

(define (member item x)
  (cond ((null? x) false)
        ((equal? item (car x)) true)
        (else (member item (cdr x)))))

(define (distinct? items)
  (cond ((null? items) true)
        ((null? (cdr items)) true)
        ((member (car items) (cdr items)) false)
        (else (distinct? (cdr items)))))

(define (multiple-dwelling)
  (let ((fletcher (amb 1 2 3 4 5)))
       (require (not (= fletcher 5)))
       (require (not (= fletcher 1)))
       (let ((cooper (amb 1 2 3 4 5)))
            (require (not (= cooper 1)))
            (require (not (= (abs (- fletcher cooper)) 1)))
            (let ((miller (amb 1 2 3 4 5)))
                 (require (> miller cooper))
                 (let ((baker (amb 1 2 3 4 5)))
                      (require (not (= baker 5)))
                      (let ((smith (amb 1 2 3 4 5)))
                           (require
                             (distinct? (list baker cooper fletcher miller smith)))
                           (require (not (= (abs (- smith fletcher)) 1)))
                           (list (list 'baker baker)
                                 (list 'cooper cooper)
                                 (list 'fletcher fletcher) (list 'miller miller)
                                 (list 'smith smith))))))))

(multiple-dwelling)
