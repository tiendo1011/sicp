(load "stream.scm")

(define sum 0)
(define (accum x) (set! sum (+ x sum)) sum)

(define (memo-proc proc)
  (let ((already-run? false) (result false))
       (lambda (x)
               (if (not already-run?)
                   (begin (set! result (proc x))
                          (set! already-run? true)
                          result)
                   result))))

(define memo-accum (memo-proc accum))
(memo-accum 1)
(memo-accum 1)
