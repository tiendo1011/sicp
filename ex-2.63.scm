(define (tree->list-1 tree)
  (if (null? tree)
  '()
  (append (tree->list-1 (left-branch tree))
          (cons (entry tree)
                (tree->list-1
                  (right-branch tree))))))

(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list
                              (right-branch tree)
                              result-list)))))
  (copy-to-list tree '()))

; How to know if they can produce the same result for every tree?
; How do they differ?
; The first one seems like a recursive tree process
; The second one seems like a hybrid between linear process & recursive tree process

; The first one calls the procedure itself
; The second one calls its helper procedure, and pass the result-list to it, why?

; The first one moves toward empty list
; The second one moves toward full list

; The first one uses append
; The second one uses copy-to-list

; Let's see how they handle a simple tree:
;   1
; 2   3
; procedure 1
; append (tree->list-1 (2)) (cons 1 (tree->list-1 (3)))
;=>  append
;        (append (tree->list-1 '()) (cons 2 (tree->list-1 '())))
;        (cons 1 (append (tree->list-1 '()) (cons 3 (tree->list-1 '()))))
;=>  append
;         (append '() (cons 2 '()))
;         (cons 1 (append '() (cons 3 '())))
;=>   append (2 '()) (1 3 '())) => (list 2 1 3)
;
; procedure 2
; copy-to-list (2) (cons 1 (copy-to-list (3) '()))
;=> copy-to-list (2) (cons 1 (copy-to-list '() (cons 3 (copy-to-list '() '()))))
;=> copy-to-list (2) (cons 1 (copy-to-list '() (cons 3 '())))
;=> copy-to-list (2) (cons 1 (3))
;=> copy-to-list (2) (1 3)
;=> copy-to-list '() (cons 2 (copy-to-list '() (1 3)))
;=> copy-to-list '() (cons 2 (1 3))
;=> copy-to-list '() (2 1 3)
;=> (2 1 3)

; Let's run the real tree and see
(load "tree-operation.scm")
(define tree1 (make-tree 7
                         (make-tree 3
                                    (make-tree 1 '() '())
                                    (make-tree 5 '() '()))
                         (make-tree 9
                                    '()
                                    (make-tree 11 '() '()))))

(define tree2 (make-tree 3
                         (make-tree 1 '() '())
                         (make-tree 7
                                    (make-tree 5 '() '())
                                    (make-tree 9
                                               '()
                                               (make-tree 11 '() '())))) )

(define tree3 (make-tree 5
                         (make-tree 3
                                    (make-tree 1 '() '())
                                    '())
                         (make-tree 9
                                    (make-tree 7 '() '())
                                    (make-tree 11 '() '()))))

(tree->list-1 tree1)
(tree->list-2 tree1)
(tree->list-1 tree2)
(tree->list-2 tree2)
(tree->list-1 tree3)
(tree->list-2 tree3)

; a. It seems like they're the same
; b. The order of growth is actually quite interesting
; For tree->list-1, each call feeds the next calls with half the tree, so we have:
; T(n) = 2*T(n/2) + O(n/2) (O(n/2) comes from the call to append)
; t(n) = n/2 + 2*t(n/2)
;      = n/2 + 2*(n/4 + 2*t(n/4))
;      = n/2 + n/2 + 4*t(n/4)
;      ...
; There will be log(n) calls, so we have log(n) * n/2 times
; 4*T(n/4) has O(n) complexity
; It's nlog(n) Time complexity
; More elaborate explanation: https://stackoverflow.com/a/62259068/4632735

; For tree->list-2:
; T(n) = 2*T(n/2)
; T(n) = 2*(2*T(n/4))
; So it's log(n) Complexity

; Before that, I assume that tree recursive process will have O(n2) time complexity
; taken from the 8 queens puzzle exercise
; Turns out beside the number of calls you make to itself,
; it also depends on the number of elements you feed to the call after each step
; will put it to README
