(load "a-register-machine-simulator.scm")

(define factorial-machine
  (make-machine
    '(continue n val)
    (list (list '= =) (list '- -) (list '* *))
    '((assign continue (label fact-done))
      fact-loop
        (test (op =) (reg n) (const 1))
        (branch (label base-case))
        (save continue)
        (save n)
        (assign n (op -) (reg n) (const 1))
        (assign continue (label after-fact))
        (goto (label fact-loop))
      after-fact
        (restore n)
        (restore continue)
        (assign val (op *) (reg n) (reg val))
        (goto (reg continue))
      base-case
        (assign val (const 1))
        (goto (reg continue))
      fact-done)))

(for-each (lambda (n)
            (begin
              (set-register-contents! factorial-machine 'n n)
              (start factorial-machine)
              (display (get-register-contents factorial-machine 'val))
              ((factorial-machine 'stack) 'print-statistics))
              (newline))
          (list 2 3 4 5 6 7))
