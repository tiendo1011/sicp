(load "stream-paradigm.scm")

(define (pairs s t)
  (cons-stream
    (list (stream-car s) (stream-car t))
    (interleave
      (stream-map (lambda (x) (list x (stream-car t)))
                  (stream-cdr s))
      (interleave
        (stream-map (lambda (x) (list (stream-car s) x))
                    (stream-cdr t))
        (pairs (stream-cdr s) (stream-cdr t))))))

; the original pairs form:
; (1,1), (1,2), (1,3), (1,4), (1,5), (1,6), (1,7)...
;        (2,2), (2,3), (2,4), (2,5), (2,6), (2,7)...
;               (3,3), (3,4), (3,5), (3,6), (3,7)...
;                      (4,4), (4,5), (4,6), (4,7)...
;                             (5,5), (5,6), (5,7)...

; the suplement form:
;
; (2,1)
; (3,1), (3,2)
; (4,1), (4,2), (4,3)

(define pairs-stream (pairs integers integers))
(display-stream-with-limit pairs-stream 20)
; Then organize it
; (1 1)(1 2)(1 3)(1 4)(1 5)(1 6)
; (2 1)(2 2)(2 3)
; (3 1)(3 2)
; (4 1)(4 2)
; (5 1)
; (6 1)
; (7 1)
; (8 1)
; (9 1)
; (10 1)
; (11 1)
