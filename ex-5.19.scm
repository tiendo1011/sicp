; Q: How do you mark the breakpoint?
; A: have a list of breakpoints and check when the execution hit the breakpoint

; Q: How do you stop the machine when it hits the breakpoint?
; A: You just don't call execute

; Q: How do you allow user to send message to it to get information
; A: just allow user to send the message to the machine

; Q: How do you continue the machine?
; A: You run execute

; I think it'll be fun to do this exercise, so I'll find a way to do it
; The new feature will be integrated into a-register-machine-simulator.scm
; Here is the code to test it
(load "a-register-machine-simulator.scm")
(define gcd-machine
  (make-machine
    '(a b t)
    (list (list 'rem remainder) (list '= =))
    '(test-b
      (test (op =) (reg b) (const 0))
      (branch (label gcd-done))
      (assign t (op rem) (reg a) (reg b))
      (assign a (reg b))
      (assign b (reg t))
      (goto (label test-b))
      gcd-done)))
(set-breakpoint gcd-machine 'test-b 4)
(set-breakpoint gcd-machine 'test-b 5)
(set-register-contents! gcd-machine 'a 206) ; done
(set-register-contents! gcd-machine 'b 40) ; done
(start gcd-machine) ;
(get-register-contents gcd-machine 'a) ; should be 206, since it pauses before 'test-b 4

(proceed-machine gcd-machine)
(get-register-contents gcd-machine 'a) ; should be 40, since it pauses before 'test-b 5 after assigning a

(cancel-breakpoint gcd-machine 'test-b 4)
(proceed-machine gcd-machine)
(get-register-contents gcd-machine 'a) ; should be 6, since it pauses before 'test-b 5 after assigning a

(cancel-all-breakpoints gcd-machine)
(proceed-machine gcd-machine) ; should print 'done
