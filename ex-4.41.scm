; Write an ordinary Scheme program to solve the multiple dwelling puzzle.

; The idea is to generate all possible combinations
; And filter it base on the provided conditions
; Then returns what's left

; First bite: Generate all possible combinations
; Seems like a recursive problems to me
; (1 2 3 4 5)
; = combinations that has 1 at the beginning
; + combinations that has 2 at the beginning
; + combinations that has 3 at the beginning
; + combinations that has 4 at the beginning
; + combinations that has 5 at the beginning

; a-list = a-member + the rest
;        = a-member + (filter not-a-member a-list)

(load "list-operation.scm")
(define (to-a-member-and-the-rest-combinations a-list)
  (map
    (lambda (a-member)
            (list a-member (filter (lambda (x) (not (equal? a-member x))) a-list)))
    a-list))

(define (permutation a-list)
  (if (null? a-list)
      '()
      (let ((a-member-and-the-rest-list (to-a-member-and-the-rest-combinations a-list)))
           (flatmap (lambda (a-member-and-the-rest)
                  (let ((permutation-of-the-rest (permutation (cadr a-member-and-the-rest))))
                    (if (null? permutation-of-the-rest)
                      (list (car a-member-and-the-rest))
                      (map (lambda (combination)
                                   (cons (car a-member-and-the-rest)
                                         combination))
                           permutation-of-the-rest))))
                a-member-and-the-rest-list))))

(define (multiple-dwelling)
  (let ((all-combinations (permutation '(1 2 3 4 5))))
    (filter (lambda (combination)
              (let ((baker (car combination))
                    (cooper (cadr combination))
                    (fletcher (caddr combination))
                    (miller (cadddr combination))
                    (smith (cddddr combination)))
                    (and
                      (not (= baker 5))
                      (not (= cooper 1))
                      (not (= fletcher 5))
                      (not (= fletcher 1))
                      (> miller cooper)
                      (not (= (abs (- smith fletcher)) 1))
                      (not (= (abs (- fletcher cooper)) 1)))))
            all-combinations)))

(display (multiple-dwelling))
; Just wonder if we can re-organize it like ex-4.40 to make it more efficient
; For example, we choose a floor for baker & then filter it out, before continuing with other
; I'm not sure how to do it though
