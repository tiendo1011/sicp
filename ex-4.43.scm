; Who is Lorna’s father?
; How to we know?

; Fathers: Mr.Moore, Mr.Colonel, Mr.Hall, Mr.Barnacle, and Mr.Parker
; Mr.Barnacle's yacht: Gabrielle
; Mr.Moore's yacht: Lorna
; Mr.Hall's yacht: Rosalind
; Mr.Colonel's yacht: Melissa (Barnacle's daughter)
; Mr.Parker's yacht: Mary Moore

; Gabrielle's father yacht name: x (Dr.Parker's daughter)
(load "metacircular-evaluator-amb-evaluation.scm")

; (define the-global-environment (setup-environment))
(driver-loop)

(define (require p) (if (not p) (amb)))

(define (member item x)
  (cond ((null? x) false)
        ((equal? item (car x)) true)
        (else (member item (cdr x)))))

(define (distinct? items)
  (cond ((null? items) true)
        ((null? (cdr items)) true)
        ((member (car items) (cdr items)) false)
        (else (distinct? (cdr items)))))

(define (find a-list proc)
  (if (proc (car a-list))
    (car a-list)
    (find (cdr a-list) proc)))

(define (find-yatch-name owner-to-yacht-mapping owner)
  (car (cdr (find
                  owner-to-yacht-mapping
                  (lambda (item) (equal? (car item) owner))))))

(define (find-daughter-name father-to-daughter-mapping father)
  (car (cdr (find
    father-to-daughter-mapping
    (lambda (item) (equal? (car item) father))))))

(define (fathers)
  (let ((gabrielle-father (amb 'mrmoore 'mrcolonel 'mrhall 'mrbarnacle 'mrparker))
        (lorna-father (amb 'mrmoore 'mrcolonel 'mrhall 'mrbarnacle 'mrparker))
        (rosalind-father (amb 'mrmoore 'mrcolonel 'mrhall 'mrbarnacle 'mrparker))
        (melissa-father (amb 'mrmoore 'mrcolonel 'mrhall 'mrbarnacle 'mrparker))
        (mary-father (amb 'mrmoore 'mrcolonel 'mrhall 'mrbarnacle 'mrparker))
        (owner-to-yacht-mapping
          (list (list 'mrbarnacle 'gabrielle)
                (list 'mrmoore 'lorna)
                (list 'mrhall 'rosalind)
                (list 'mrcolonel 'melissa)
                (list 'mrparker 'mary))))
       (let ((father-to-daughter-mapping
               (list (list gabrielle-father 'gabrielle)
                     (list lorna-father 'lorna)
                     (list rosalind-father 'rosalind)
                     (list melissa-father 'melissa)
                     (list mary-father 'mary))))
            (require
              (distinct? (list gabrielle-father lorna-father rosalind-father melissa-father mary-father)))
            (require (not (equal? gabrielle-father 'mrbarnacle)))
            (require (not (equal? lorna-father 'mrmoore)))
            (require (not (equal? rosalind-father 'mrhall)))
            (require (not (equal? melissa-father 'mrcolonel)))
            (require (equal? melissa-father 'mrbarnacle))
            (require (not (equal? mary-father 'mrparker)))
            (require (equal? mary-father 'mrmoore))
            (let ((gabrielle-father-yatch-name (find-yatch-name owner-to-yacht-mapping gabrielle-father))
                  (mrparker-daughter-name (find-daughter-name father-to-daughter-mapping 'mrparker)))
                 (require (equal? gabrielle-father-yatch-name mrparker-daughter-name)))
            (list (list 'gabrielle-father gabrielle-father)
                  (list 'lorna-father lorna-father)
                  (list 'rosalind-father rosalind-father)
                  (list 'melissa-father melissa-father)
                  (list 'mary-father mary-father)))))

(fathers)
; ((gabrielle-father mrhall) (lorna-father mrcolonel) (rosalind-father mrparker) (melissa-father mrbarnacle) (mary-father mrmoore))

; If we are not told that mary ann's last name is Moore, then there're 2 solutions:
; ((gabrielle-father mrmoore) (lorna-father mrparker) (rosalind-father mrcolonel) (melissa-father mrbarnacle) (mary-father mrhall))
; ((gabrielle-father mrhall) (lorna-father mrcolonel) (rosalind-father mrparker) (melissa-father mrbarnacle) (mary-father mrmoore))
