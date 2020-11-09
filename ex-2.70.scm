(load "huffman-encoding-tree.scm")
(define pairs '((a 2) (boom 1) (get 2) (job 2) (sha 3) (na 16) (wah 1) (yip 9)))
(define tree (generate-huffman-tree pairs))
(encode '(get a job sha na na na na na na na na get a job sha na na na na na na na na wah yip yip yip yip yip yip yip yip yip sha boom) tree)
; How many bits are required for the encoding? 84
; Smallest number of bits if we used a fixed-length code:
; 8 chars => log2(8) = 3 bits per char, we have 36 words, that means 36 * 3 = 108 bits
