(load "square")
(load "fast-expt")
(load "report-elapsed-time")

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
          (remainder
            (square (expmod base (/ exp 2) m)) ; (1)
            m))
        (else
          (remainder
            (* base (expmod base (- exp 1) m))
            m))))

(define (modified-expmod base exp m)
  (remainder (fast-expt base exp) m))

(define start-time (runtime))
(expmod 999999 1000000 1000000)
(report-elapsed-time start-time)

(define start-time (runtime))
(modified-expmod 999999 1000000 1000000)
(report-elapsed-time start-time)
