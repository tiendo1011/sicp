(define fibs
  (cons-stream
    0
    (cons-stream 1 (add-streams (stream-cdr fibs) fibs))))

; fibs:
;     1 1 2 3 5... = stream-cdr fibs
;     0 1 1 2 3... = fibs
; 0 1 1 2 3 5 8... = fibs

; To calculate first item (0): 0
; To calculate second item (1): 0
; To calculate third item (1): 1 (0+1)
; To calculate forth item (2): 2 (1+1, 0+1)
; To calculate fifth item (3): 3 (2+1, 1+1, 0+1)
; To calculate sixth item (5): 4 (3+2, 2+1, 1+1, 0+1)
; To calculate seventh item (8): 5 (5+3, 3+2, 2+1, 1+1, 0+1)
