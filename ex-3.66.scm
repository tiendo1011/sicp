(load "stream-paradigm.scm")

(define (pairs s t)
  (cons-stream
    (list (stream-car s) (stream-car t))
    (interleave
      (stream-map (lambda (x) (list (stream-car s) x))
                  (stream-cdr t))
      (pairs (stream-cdr s) (stream-cdr t)))))

(define pairs-stream (pairs integers integers))
; the form:
; (1,1), (1,2), (1,3), (1,4), (1,5), (1,6), (1,7)...
;        (2,2), (2,3), (2,4), (2,5), (2,6), (2,7)...
;               (3,3), (3,4), (3,5), (3,6), (3,7)...
;                      (4,4), (4,5), (4,6), (4,7)...
;                             (5,5), (5,6), (5,7)...

(display-stream-with-limit pairs-stream 50)
; approximately how many pairs precede the pair (1, 100)?
; The first is (1 1)
; the next one, we have each (1 x) will couple with a pair from the other stream
; So the pairs before (1 100) is:
; 1 + (99-2+1)*2 pairs = 1 + 98*2 = 197 pairs

; approximately how many pairs precede the pair (99, 100)?
; The stream:
; (1 1)(1 2)
;      (2 2)(1 3) (2 3)(1 4)
;           (3 3)(1 5)(2 4)(1 6) (3 4)(1 7)(2 5)(1 8)
;                (4 4)(1 9)(2 6)(1 10)(3 5)(1 11)(2 7)(1 12) (4 5)(1 13)(2 8)(1 14)(3 6)(1 15)(2 9)(1 16)
;                     (5 5)(1 17)(2 10)(1 18)(3 7)(1 19)(2 11)(1 20)(4 6)(1 21)(2 12)(1 22)(3 8)(1 23)(2 13)(1 24) (5 6)(1 25)(2 14)(1 26)
;                        ....
;                          (99 99) ... (99 100)
;                                (100 100)

; 2^1 + 2^2 + 2^3 + 2^4 + ... + 2^98 + (2^99)/2

; approximately how many pairs precede the pair (100, 100)?
; 2^1 + 2^2 + 2^3 + 2^4 + ... + 2^99
