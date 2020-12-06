; return 0 if call f 0 then f 1
; to return 0 then both f 0 & f 1 has to return 0

; return 1 if call f 1 then f 0
; to return 1 then f 1 return 1, f 0 return 0

(define f
  (let ((is-called false))
       (lambda (m)
               (cond ((eq? m 0) (begin (set! is-called true) 0))
                     ((eq? m 1) (if is-called
                                    0
                                    1))))))


(+ (f 0) (f 1))
