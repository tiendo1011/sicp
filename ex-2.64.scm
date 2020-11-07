(define (list->tree elements)
  (car (partial-tree elements (length elements))))

(define (list->tree elements)
  (car (partial-tree elements (length elements))))
(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
           (let ((left-result
                   (partial-tree elts left-size)))
                (let ((left-tree (car left-result))
                      (non-left-elts (cdr left-result))
                      (right-size (- n (+ left-size 1))))
                     (let ((this-entry (car non-left-elts))
                           (right-result
                             (partial-tree
                               (cdr non-left-elts)
                               right-size)))
                          (let ((right-tree (car right-result))
                                (remaining-elts
                                  (cdr right-result)))
                               (cons (make-tree this-entry
                                                left-tree
                                                right-tree)
                                     remaining-elts))))))))

; First calls:
; Make a tree from
;   this-entry: The element in the middle if (n - 1) % 2 == 0, The element in the left middle if (n - 1) % 2 == 1
;   left-tree: Tree built from the left
;   right-tree: Tree built from the right
; elements left
; cons these 2 together

(list->tree (list 1 3 5 7 9 11))

;b. Master theorem:
; Base on wiki: https://en.wikipedia.org/wiki/Master_theorem_(analysis_of_algorithms)
; T(n) = aT(n/b) + f(n)
; We have 3 cases:
; 1. Work to split/recombine a problem is dwarfed by subproblems.
; 2. Work to split/recombine a problem is comparable to subproblems.
; 3. Work to split/recombine a problem dominates subproblems.
; First we find a, b, then find logb(a) => That's the power of n we're looking for, then compare with f(n)
; Testing it with the list in wiki and https://www.csd.uwo.ca/~mmorenom/CS433-CS9624/Resources/master.pdf
; yield 91% correct (only 2 cases with n/logn remains, which is related to how it determine non-polynomial difference
; between f(n) and n^(logb(a)))
; Follow the definition of polynomial, the explanation seems confused to me
; So it'll be conservative and follow this strategy:
; 1. Compare logb(a) and f(n) to see if the difference is polinomial
; If not, then master theorem does not apply
; If is, then master theorem applies with the three above case
; (mind the regularity condition for case 3, where af(n/b) <= kf(n) for k < 1 and sufficient large n
; The post bellow seems to follow the same conservative view: https://brilliant.org/wiki/master-theorem/
; Let's go with that for now
