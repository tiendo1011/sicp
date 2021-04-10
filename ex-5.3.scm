(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) 0.001))
  (define (improve guess)
    (average guess (/ x guess)))
  (define (sqrt-iter guess)
    (if (good-enough? guess)
        guess
        (sqrt-iter (improve guess))))
  (sqrt-iter 1.0))

; sqrt machine description
; version 1 (assuming that good-enough? & improve operations are available as primitives)
(define (sqrt x)
  (define (sqrt-iter guess)
    (if (good-enough? guess)
        guess
        (sqrt-iter (improve guess))))
  (sqrt-iter 1.0))
; I drew the data-path diagram in paper
; Here I write a controller definition in the register machine language
(controller
  (assign guess (const 1.0))
  test-guess
  (test (op good-enough?) (reg guess))
  (branch (label sqrt-done))
  (assign guess (op improve) (reg guess))
  (goto (label test-guess))
  sqrt-done)

; version 2 (good-enough? & improve operations are represent as arithmetic operations)
; let's start with good-enough? (assume that improve is primitive)
(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) 0.001))
  (define (sqrt-iter guess)
    (if (good-enough? guess)
        guess
        (sqrt-iter (improve guess))))
  (sqrt-iter 1.0))

(controller
  (assign guess (const 1.0))
  test-good-enough?
    (test (op <) ((op abs) (op -) ((op square) (reg guess)) (reg x)) (const 0.001))
    (branch (label sqrt-done))
    (assign guess (op improve) (reg guess))
    (goto (label test-good-enough?))
  sqrt-done)

; then add improve to the mix
(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) 0.001))
  (define (improve guess)
    (average guess (/ x guess)))
  (define (sqrt-iter guess)
    (if (good-enough? guess)
        guess
        (sqrt-iter (improve guess))))
  (sqrt-iter 1.0))

(controller
  (assign guess (const 1.0))
  test-good-enough?
    (test (op <) ((op abs) (op -) ((op square) (reg guess)) (reg x)) (const 0.001))
    (branch (label sqrt-done))
    (goto (label improve))
  improve
    (assign guess (op average) (reg guess) ((op /) (reg x) (reg guess)))
    (goto (label test-good-enough?))
  sqrt-done)
