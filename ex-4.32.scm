; How lazy is it?
; From the book:
; Note that these lazy lists are even lazier than the streams of Chapter 3:
; The car of the list, as well as the cdr , is delayed. 41 In fact, even accessing
; the car or cdr of a lazy pair need not force the value of a list element.
; The value will be forced only when it is really needed—e.g., for use as
; the argument of a primitive, or to be printed as an answer.

; As the example in the book:
(define (solve f y0 dt)
  (define y (integral dy y0 dt))
  (define dy (map f y))
  y)

; No need to delay dy in y definition
