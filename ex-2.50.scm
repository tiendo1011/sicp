(define (rotate90 painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)))


; flip-horiz pseudocode
; new-origin: 1, 0
; edge1: 0, 0
; edge2: 1, 1

(define (flip-horiz painter)
  (transform-painter
    painter
    (make-vect 1 0)
    (make-vect 0 0)
    (make-vect 1 1)))

; rotate180 pseudocode
; new-origin: 1, 1
; edge1: 0, 1
; edge2: 1, 0

(define (rotate180 painter)
  (transform-painter
    painter
    (make-vect 1 1)
    (make-vect 0 1)
    (make-vect 1 0))

; rotate270 pseudocode
; new-origin: 0, 1
; edge1: 0, 0
; edge2: 1, 1

 define (rotate270 painter)
  (transform-painter
    painter
    (make-vect 0 1)
    (make-vect 0 0)
    (make-vect 1 1))
