; From let* to let
(let* ((x 3)
       (y x))
      (* x y))

; =>
(let ((x 3))
  (let ((y x))
    (* x y)))

; The implementation is integrated into metacircular-evaluator.scm
; Which also proves that it's sufficient to add a clause to eval whose action is
; (eval (let*->nested-lets exp) env)
