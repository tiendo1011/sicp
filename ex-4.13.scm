; I'd like it to remove all the binding in env
; Just to avoid any surprises

(define (clear-variable! var env)
  (if (eq? env the-empty-environment)
      'done
      (let* ((frame (first-frame env))
             (var-index (find-index (frame-variables frame) var)))
            (if (eq? var-index -1)
                (clear-variable! var (enclosing-environment env))
                (set-car!
                  env
                  (make-frame
                    (frame-variables-without-var-at-index frame var-index)
                    (frame-values-without-val-at-index frame var-index)))))))

(define (frame-variables-without-var-at-index frame var-index)
    (remove-item-at-index (frame-variables frame) var-index))

(define (frame-values-without-val-at-index frame var-index)
    (remove-item-at-index (frame-values frame) var-index))
