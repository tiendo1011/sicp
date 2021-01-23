(load "square.scm")
(load "stream-paradigm.scm")

(define (pairs s t)
  (cons-stream
    (list (stream-car s) (stream-car t))
    (interleave
      (stream-map (lambda (x) (list (stream-car s) x))
                  (stream-cdr t))
      (pairs (stream-cdr s) (stream-cdr t)))))

; The form
; SoToUo, SoToU1, SoToU2
;         SoT1U1, SoT1U2
; S1T1U1, S1T1U2, S1T1U3
; So it's have the form:
; SoToUo + (stream-map (So + y) (ToU1 ToU2, T1U1, T1U2...)) + triples S1 T1 U1

(define (triples s t u)
  (cons-stream
    (list (stream-car s) (stream-car t) (stream-car u))
    (interleave
      (stream-map
        (lambda (y) (cons (stream-car s) y))
        (interleave
          (stream-map (lambda (x) (list (stream-car t) x))
                      (stream-cdr u))
          (pairs (stream-cdr t) (stream-cdr u))))
      (triples (stream-cdr s) (stream-cdr t) (stream-cdr u)))))

(define triples-stream (triples integers integers integers))

(define (pythagorean-triple? a b c)
  (= (+ (square a) (square b)) (square c)))
(define pythagorean-triples-stream
  (stream-filter
    (lambda (t) (pythagorean-triple? (car t) (cadr t) (caddr t)))
    triples-stream))

(display-stream-with-limit pythagorean-triples-stream 3)
