(load "list-operation.scm")

(define (make-leaf symbol weight) (list 'leaf symbol weight))
(define (leaf? object) (eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))

(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))
(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))

(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))
(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))

(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
        '()
        (let ((next-branch
                (choose-branch (car bits) current-branch)))
             (if (leaf? next-branch)
                 (cons (symbol-leaf next-branch)
                       (decode-1 (cdr bits) tree))
                 (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))
(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "bad bit: CHOOSE-BRANCH" bit))))

(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set))
        (else (cons (car set)
                    (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
           (adjoin-set (make-leaf (car pair)
                                  (cadr pair))
                       (make-leaf-set (cdr pairs))))))

; successive-merge pseudocode
; terminate condition: set has only one element
; if not, get 2 first element of the set, merge them
; removes the 2 elements and adjoin the newly merged element to the list
; calls successive-merge with the new set

(define (successive-merge set)
  (if (= (length set) 1)
      (car set) ; a set contains the huffman-tree [tree], to get tree, we need to call car set
      (let ((node1 (list-ref set 0))
            (node2 (list-ref set 1)))
        (successive-merge (adjoin-set (make-code-tree node1 node2) (cddr set))))))

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

; encode-symbol pseudocode
; check if the root contains symbol, if not return error
; else start from the root, see if the symbol is in left or right branch
; if it's in the right, add 1
; if it's in the left, add 0
; repeat with the new branch as root
; terminal condition: reach leaf, then return '()

(define (symbol-in-tree symbol tree)
  (include? (symbols tree) symbol equal?))

(define (symbol-in-left-branch? symbol tree)
  (symbol-in-tree symbol (left-branch tree)))

(define (encode-symbol symbol tree)
  (define (tree-iter symbol tree)
    (if (not (leaf? tree))
        (if (symbol-in-left-branch? symbol tree)
            (cons '0 (encode-symbol symbol (left-branch tree)))
            (cons '1 (encode-symbol symbol (right-branch tree))))
        '()))
  (if (not (symbol-in-tree symbol tree))
      (error "no matching symbol found")
      (tree-iter symbol tree)))

(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))

(define sample-tree (generate-huffman-tree '((A 4) (B 2) (C 1) (D 1))))
(decode (encode '(A B D C) sample-tree) sample-tree)
