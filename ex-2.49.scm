(define (segments->painter segment-list)
  (lambda (frame)
          (for-each
            (lambda (segment)
                    (draw-line
                      ((frame-coord-map frame)
                       (start-segment segment))
                      ((frame-coord-map frame)
                       (end-segment segment))))
            segment-list)))

(define (outline frame)
  ((segments->painter
     (list
       (make-segment (make-vect 0 0) (make-vect 1 0))
       (make-segment (make-vect 1 0) (make-vect 1 1))
       (make-segment (make-vect 1 1) (make-vect 0 1))
       (make-segment (make-vect 0 1) (make-vect 0 0))))
   frame))

(define (x frame)
  ((segments->painter
     (list
       (make-segment (make-vect 0 0) (make-vect 1 1))
       (make-segment (make-vect 1 0) (make-vect 0 1))))
   frame))

(define (midpoints frame)
  ((segments->painter
     (list
       (make-segment (make-vect 0.5 0) (make-vect 1 0.5))
       (make-segment (make-vect 1 0.5) (make-vect 0.5 1))
       (make-segment (make-vect 0.5 1) (make-vect 0 0.5))
       (make-segment (make-vect 0 0.5) (make-vect 0.5 0))))
   frame))

; The wave
; My thought is that if we have enough segment, we can make the wave
; Although it will not look as good as printed in the book
; But it's ok, I guess.
; It's possible to use the one added by billthelizard:
; https://billthelizard.blogspot.com/2011/10/sicp-249-defining-primitive-painters.html
