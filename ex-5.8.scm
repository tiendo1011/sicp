; let's see how extract-labels works with the text
(define (extract-labels text receive)
  (if (null? text)
      (receive '() '())
      (extract-labels
        (cdr text)
        (lambda (insts labels)
                (let ((next-inst (car text)))
                     (if (symbol? next-inst)
                         (receive insts
                                  (cons (make-label-entry next-inst
                                                          insts)
                                        labels))
                         (receive (cons (make-instruction next-inst)
                                        insts)
                                  labels)))))))

; =>
; text1:
(start
 (goto (label here))
here
  (assign a (const 3))
  (goto (label there))
here
  (assign a (const 4))
  (goto (label there))
there)

(extract-labels text1 receive) ; (1)

; =>
; text2:
(
 (goto (label here))
here
  (assign a (const 3))
  (goto (label there))
here
  (assign a (const 4))
  (goto (label there))
there)

(extract-labels
  text2
  (lambda (insts labels) ; (2)
    (let ((next-inst 'start))
      (receive insts (cons (make-label-entry next-inst insts) labels)))

; =>
; text3
(
here
  (assign a (const 3))
  (goto (label there))
here
  (assign a (const 4))
  (goto (label there))
there)

(extract-labels
  text3
  (lambda (insts labels) ; (3)
    (let ((next-inst (goto (label here))))
      (receive (cons (make-instruction next-inst) insts) labels))))

;=>
; text4
(
  (assign a (const 3))
  (goto (label there))
here
  (assign a (const 4))
  (goto (label there))
there)

(extract-labels
  text4
  (lambda (insts labels) ; (4)
    (let ((next-inst 'here))
      (receive insts (cons (make-label-entry next-inst insts)) labels))))

; =>
; text5
(
  (goto (label there))
here
  (assign a (const 4))
  (goto (label there))
there)

(extract-labels
  text5
  (lambda (insts labels) ; (5)
    (let ((next-inst (assign a (const 3))))
      (receive (cons (make-instruction next-inst) insts) labels))))

; =>
; text6
(
here
  (assign a (const 4))
  (goto (label there))
there)

(extract-labels
  text6
  (lambda (insts labels) ; (6)
    (let ((next-inst (goto (label there))))
      (receive (cons (make-instruction next-inst) insts) labels))))

; =>
; text7
(
  (assign a (const 4))
  (goto (label there))
there)

(extract-labels
  text7
  (lambda (insts labels) ; (7)
    (let ((next-inst 'here))
      (receive insts (cons (make-label-entry next-inst insts) labels)))))

; =>
; text8
(
  (goto (label there))
there)

(extract-labels
  text8
  (lambda (insts labels) ; (8)
    (let ((next-inst (assign a (const 4))))
      (receive (cons (make-instruction next-inst) insts) labels))))

; =>
; text9
(
there)

(extract-labels
  text9
  (lambda (insts labels) ; (9)
    (let ((next-inst (goto (label there))))
      (receive (cons (make-instruction next-inst) insts) labels))))

; =>
; text10
()

(extract-labels
  text10
  (lambda (insts labels) ; (10)
    (let ((next-inst 'there))
      (receive insts (cons (make-label-entry next-inst insts) labels)))))

; =>
(receive '() '())

; =>
; (10) is called, result in:
(receive '() '(there '()))

; =>
; (9) is called, result in:
(receive '((goto (label there)) '()) '()) '(there '())

; =>
; (8) is called, result in:
(receive '((assign a (const 4)) (goto (label there)) ()) (there '()))

; =>
; (7) is called, result in:
(receive '((assign a (const 4)) (goto (label there)) ()) ((here ((assign a (const 4)) (goto (label there)) ())) (there '())))

; =>
; (6) is called, result in:
(receive '((goto (label there))
           (assign a (const 4))
           (goto (label there))
           ())
        '((here ((assign a (const 4)) (goto (label there)) ()))
          (there '())))

; =>
; (5) is called, result in:
(receive '((assign a (const 3))
           (goto (label there))
           (assign a (const 4))
           (goto (label there))
           ())
        '((here ((assign a (const 4)) (goto (label there)) ()))
          (there '())))

; =>
; (4) is called, result in:
(receive '((assign a (const 3))
           (goto (label there))
           (assign a (const 4))
           (goto (label there))
           ())
        '((here ((assign a (const 3)) (goto (label there)) (assign a (const 4)) (goto (label there)) ()))
          (here ((assign a (const 4)) (goto (label there)) ()))
          (there '())))

; =>
; (3) is called, result in:
(receive '((goto (label here))
           (assign a (const 3))
           (goto (label there))
           (assign a (const 4))
           (goto (label there))
           ())
        '((here ((assign a (const 3)) (goto (label there)) (assign a (const 4)) (goto (label there)) ()))
          (here ((assign a (const 4)) (goto (label there)) ()))
          (there '())))

; =>
; (2) is called, result in:
(receive '((goto (label here))
           (assign a (const 3))
           (goto (label there))
           (assign a (const 4))
           (goto (label there))
           ())
        '((start ((goto (label here)) (assign a (const 3)) (goto (label there)) (assign a (const 4)) (goto (label there)) ()))
          (here ((assign a (const 3)) (goto (label there)) (assign a (const 4)) (goto (label there)) ()))
          (here ((assign a (const 4)) (goto (label there)) ()))
          (there '())))

; =>
; (1) is called, with insts & labels as above

; Let's guess how it works
; first, execute start
; which trigger the first inst, which is (goto (label here))
; this will jump to a label here, but which "here" does it jump to?
; 1. If it jumps to the first "here"
; (assign a 3)
; (goto (label there))
; which jump to there, since there is no more inst to execute, it terminated

; 2. If it jumps to the second "here"
; (assign a 4)
; (goto (label there))
; which jump to there, since there is no more inst to execute, it terminated

; How do I know if it jumps to the first "here" or the second
; since this is a list, It's much likely to jump to the first, than to the second
; so My guess is register a will be set to 3

; The check is integrated into a-register-machine-simulator.scm
