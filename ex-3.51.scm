(define (show x)
  (display-line x)
  x)

(define x
  (stream-map show
              (stream-enumerate-interval 0 10)))

(stream-enumerate-interval 0 10)
#1 (cons 0 (delay (stream-enumerate-interval 1 10)))

(stream-map show
            (stream-enumerate-interval 0 10)))
#2 (cons 0 (delay (stream-map show (stream-cdr #1))))
; For stream, if it yields the first value, the next force will make it yield the next value
; Can it not yield the next value?
; Possible, if the body contains branches (if ...)

(stream-ref x 5)
; first iteration:
(stream-ref (stream-map show (stream-cdr #1)) 4) (1)
; First it excecute (stream-cdr #1)
; which execute (stream-enumerate-interval 1 10)
; which returns (cons 1 (delay (stream-enumerate-interval 2 10)))
; So (1) becomes
(stream-ref (stream-map show (cons 1 (delay (stream-enumerate-interval 2 10)))) 4) (1)
; evaluate (stream-map show (cons 1 (delay (stream-enumerate-interval 2 10))))
; cons 1 (delay (stream-map show (stream-cdr (cons 1 (delay (stream-enumerate-interval 2 10))))))


; (stream-ref x 7)
