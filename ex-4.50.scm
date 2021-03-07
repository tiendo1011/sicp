; Test code to validate ramb works
(load "metacircular-evaluator-amb-evaluation.scm")
(driver-loop)

(define (require p) (if (not p) (amb)))

(define (a-random-element-of items)
  (require (not (null? items)))
  (ramb (car items) (a-random-element-of (cdr items))))

(a-random-element-of '(1 2 3 4 5))

; In my first attempt, i implement analyze-ramb like this:

; (define (ramb-choices exp)
;   (let ((choices (amb-choices exp)))
;     (shuffle choices)))

; (define (analyze-ramb exp)
;   (let ((cprocs (map analyze (ramb-choices exp))))
;        (lambda (env succeed fail)
;                (define (try-next choices)
;                  (if (null? choices)
;                      (fail)
;                      ((car choices)
;                       env
;                       succeed
;                       (lambda () (try-next (cdr choices))))))
;                (try-next cprocs))))

; The idea is that I shuffle the choices before feeding it
; to the handler
; The problem with that is the shuffle happens before analyze,
; The order of choices is actually fixed before executing
; Let's use a-random-element-of procedure above to illustrate this:
; In that procedure, there is a call to ramb:
(ramb (car items) (a-random-element-of (cdr items)))
; so we have 2 choices: (car items) & (a-random-element-of (cdr items))

; When the amb evaluator encounter the definition of a-random-element-of, it starts
; analyzing the body of the procedure, where it encounters ramb calls
; which triggers analyze-ramb
; this in turn shuffle the choices, and the result if 1 of 2 possible outcomes:
((car items) (a-random-element-of (cdr items))) ; (1)
; or
((a-random-element-of (cdr items)) (car items)) ; (2)

; For the (1) case, when executing (a-random-element-of '(1 2 3 4 5))
; when encounter the (ramb (car items) (a-random-element-of (cdr items)))
; it'll call (car choices) & it'll always return the first choice (which is (car items))
; executing it returns the first element from the list
; If we press try-again, it'll trigger the fail branch from analyze-ramb, which is
; (lambda () (try-next (cdr choices)))
; this will calls try-next with ((a-random-element-of (cdr items)))
; this will execute (a-random-element-of (cdr items))
; this is the same of the starting call, except that the items is now only '(2 3 4 5)

; For the (2) case, it runs in the opposite direction
; when executing (a-random-element-of '(1 2 3 4 5))
; when encounter the (ramb (car items) (a-random-element-of (cdr items)))
; it'll call (a-random-element-of (cdr items))
; which triggers (a-random-element-of '(2 3 4 5))
; ...
; until it triggers (a-random-element-of '())
; which will fails
; then amb will try to trigger the nearst ramb branch
; which is the (car items) of the last element (which is 5)
; You can imagine a series like this:
; (ramb
;   (ramb
;      (a-random-element-of '())
;      5)
;   4)
;  ...
