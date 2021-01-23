(load "stream-paradigm.scm")

; merge-weighted & weighted-pairs are implemented inside stream-paradigm.scm

; a
(define sum-pair-stream
  (weighted-pairs
    integers
    integers
    (lambda (pair) (+ (car pair) (cadr pair)))))

(display-stream-with-limit sum-pair-stream 10)

; b
(define stream2 (stream-filter
                  (lambda (i)
                          (and (not (= (modulo i 2) 0))
                               (not (= (modulo i 3) 0))
                               (not (= (modulo i 5) 0))))
                  integers))

(define sum-stream2
  (weighted-pairs
    stream2
    stream2
    (lambda (pair) (+ (* 2 (car pair)) (* 3 (cadr pair)) (* 5 (car pair) (cadr pair))))))

(display-stream-with-limit sum-stream2 10)
