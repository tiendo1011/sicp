; gcd machine description
(controller
  test-b
  (test (op =) (reg b) (const 0))
  (branch (label gcd-done))
  (assign t (op rem) (reg a) (reg b))
  (assign a (reg b))
  (assign b (reg t))
  (goto (label test-b))
  gcd-done)

; iterative factorial machine
; base on observation from ex-5.1.scm
(controller
  (assign product (const 1))
  (assign counter (const 1))
  test-counter
  (test (op >) (reg counter) (reg n))
  (branch (label factorial-done))
  (assign product (op *) (reg counter) (reg product))
  (assign counter (reg counter) (const 1))
  (goto (label test-counter))
  factorial-done)
