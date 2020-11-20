; Here is a plan for determining whether an object can be lowered:
; Begin by defining a generic operation project that “pushes” an object down
; in the tower. For example, projecting a complex number
; would involve throwing away the imaginary part. Then a
; number can be dropped if, when we project it and raise
; the result back to the type we started with, we end up with
; something equal to what we started with.
; => That's pretty clever way of doing it
(load "ex-2.79.scm") ; Load equ? which is capable of testing 2 args of the same type, either integer, rational, complex
; project pseudocode
; each package needs its own way of projecting down

(define (install-scheme-number-package)
  (define (project x) (error "Can't project integer number"))
  (put 'project 'scheme-number project)
  'done)

(define (install-rational-package)
  (define (project x)
    (attach-tag 'scheme-number (round (/ (numer (contents x)) (denom (contents x))))))
  (put 'project 'rational project)
  'done)

(define (install-real-package)
  (define (project x) (attach-tag 'scheme-number (round (contents x))))
  (put 'project 'real project)
  'done)

(define (install-complex-package)
  (define (project x) (attach-tag 'real (real-part (contents x))))
  (put 'project 'complex project)
  'done)

(define (drop x)
  (let ((project-proc (get 'project (type-tag x))))
       (if project-proc                                 ; Notice this check, I often forget these boundary condition
                                                        ; where the project-proc doesn't exists
           (let ((project-number (project-proc x)))
                (if (equ? (raise project-number) x)
                    (drop project-number)
                    x))
           x)))

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
       (let ((proc (get op type-tags)))
            (if proc
                (drop (apply proc (map contents args))) ; We add drop here
                (if (same-type? type-tags)
                    (error "No method found for" (list op type-tags))
                    (for-each-with-index
                      (lambda (arg, index)
                              (let ((coerced-args (coerce-args args index)))
                                   (apply-generic op coerced-args)))
                      args))))))
