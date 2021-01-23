(load "stream-paradigm.scm")

; Louis Reasoner thinks that building a stream of pairs from three parts is unnecessarily complicated.
; Instead of separating the pair (So,To) from the rest of the pairs
; in the first row, he proposes to work with the whole first row, as follows:
(define (pairs s t)
  (interleave
    (stream-map (lambda (x) (list (stream-car s) x))
                t)
    (pairs (stream-cdr s) (stream-cdr t))))
; Does this work?

; How to I know if it works?
; The only difference is cons-stream, I feel like there're something there
; The stream often start with a static element, starting with cons-stream
; So that the next call has something to start with
; Actually, the point is not for the next call to have something to start with
; The point is to DELAY the evaluation of the exp
; Without cons-stream, the exp evaluated immediately
; So we don't have the stream we need
