; below pseudocode
; draw painter1 in the bottom
; origin: 0, 0
; edge1: 1, 0
; edge2: 0, 0.5
; draw painter2 in the top
; origin: 0, 0.5
; edge1: 1, 0
; edge2: 0, 1

(define (below painter1 painter2)
  (let ((split-point (make-vect 0 0.5)))
       (let ((paint-bottom
               (transform-painter
                 painter1
                 (make-vect 0.0 0.0)
                 (make-vect 1 0)
                 split-point))
             (paint-top
               (transform-painter
                 painter2
                 split-point
                 (make-vect 1.0 0.0)
                 (make-vect 0.0 1.0))))
            (lambda (frame)
                    (paint-bottom frame)
                    (paint-top frame)))))

(define (below painter1 painter 2)
  (rotate90 (beside (rotate270 painter1) (rotate270 painter2))))