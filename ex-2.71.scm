(load "huffman-encoding-tree.scm")
; 5n-pairs
(define 5n-pairs '((a 1) (b 2) (c 4) (d 8) (e 16)))
(define 5n-tree (generate-huffman-tree 5n-pairs))
(encode '(e) 5n-tree) ; (mcons 1 '()): 1 bit
(encode '(a) 5n-tree) ; (mcons 0 (mcons 0 (mcons 0 (mcons 0 '())))): 4 bits

; 10n-pairs
(define 10n-pairs '((a 1) (b 2) (c 4) (d 8) (e 16) (f 32) (g 64) (h 128) (i 256) (k 512)))
(define 10n-tree (generate-huffman-tree 10n-pairs))
(encode '(k) 10n-tree) ; (mcons 1 '()): 1 bit
(encode '(a) 10n-tree) ; (mcons 0 (mcons 0 (mcons 0 (mcons 0 (mcons 0 (mcons 0 (mcons 0 (mcons 0 (mcons 0 '()))))))))): 9 bits
