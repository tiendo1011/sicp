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

; Order of growth: the balanced of the Huffman tree depends on the weight of the node
; So in the worst case, it's can be a left or right heavy tree
; In that case:
; Search symbol-in-tree: O(n)
; Run tree-iter
;   Check leaf?: O(1)
;   Check symbol-in-left-branch?: O(n)
;   Run encode-symbol for the branch: T(n-1)
;   Run cons: O(1)
; tree-iter order of growth
; T(n) = O(1) + O(n) + T(n-1) + O(1)
;      = T(n-1) + O(n) + 2*O(1)
;      = T(n-1) + O(n)
;      = O(n^2)
; order of growth: O(n) + O(n^2) = O(n^2)

; In case the tree is more balanced:
; tree-iter order of growth
; T(n) = O(1) + O(n/2) + T(n/2) + O(1)
;      = T(n/2) + O(n/2) + 2*O(1)
;      = T(n/2) + O(n/2)
; Use the master theorem: a = 1, b = 2, fn = O(n/2)
; it'll fall under case 3
; order of growth: O(n) + O(n/2) = O(n)

; For the most frequent: It searches the list, then found the symbol after the first attempt: O(n)
; For the least frequent: It searches the list, then search again
; for the (n-1) list, untill it reaches the last leaf, so it's O(n^2)
