; same-parity procedure pseudocode
; if source empty
;   return target
; else
;   item = car source
;   new_target = unshift item target if same-parity?(first_argument, item)
;   repeat (cdr source) new_target
(define (same-parity? item1 item2)
  (even? (- item1 item2)))

(define (same-parity first-argument . items)
  (define (same-parity-iter first-argument source target)
    (if (null? source)
        target
        (let ((item (car source)))
          (if (same-parity? first-argument item)
              (same-parity-iter first-argument (cdr source) (push target item))
              (same-parity-iter first-argument (cdr source) target)))))
  (same-parity-iter first-argument items (list first-argument)))

(same-parity 1 2 3 4 5 6 7)
(same-parity 2 3 4 5 6 7)
