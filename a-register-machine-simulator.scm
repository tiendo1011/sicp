; sample uses
; (define gcd-machine
;   (make-machine
;     '(a b t)
;     (list (list 'rem remainder) (list '= =))
;     '(test-b (test (op =) (reg b) (const 0))
;       (branch (label gcd-done))
;       (assign t (op rem) (reg a) (reg b))
;       (assign a (reg b))
;       (assign b (reg t))
;       (goto (label test-b))
;       gcd-done)))
; (set-register-contents! gcd-machine 'a 206) ; done
; (set-register-contents! gcd-machine 'b 40) ; done
; (start gcd-machine) ; done
; (get-register-contents gcd-machine 'a) ; 2
; end of sample uses

(load "list-operation.scm")
(define (make-machine register-names ops controller-text)
  (let ((machine (make-new-machine)))
       (for-each
         (lambda (register-name)
                 ((machine 'allocate-register) register-name))
         register-names)
       ((machine 'install-operations) ops)
       ((machine 'install-instruction-sequence)
        (assemble controller-text machine))
       machine))

(define (make-register name)
  (let ((contents '*unassigned*))
       (define (dispatch message)
         (cond ((eq? message 'get) contents)
               ((eq? message 'set)
                (lambda (value) (set! contents value)))
               (else
                 (error "Unknown request: REGISTER" message))))
       dispatch))
(define (get-contents register) (register 'get))
(define (set-contents! register value)
  ((register 'set) value))

(define (make-stack)
  (let ((s '())
        (number-pushes 0)
        (max-depth 0)
        (current-depth 0))
       (define (push x)
         (set! s (cons x s))
         (set! number-pushes (+ 1 number-pushes))
         (set! current-depth (+ 1 current-depth))
         (set! max-depth (max current-depth max-depth)))
       (define (pop)
         (if (null? s)
             (error "Empty stack: POP")
             (let ((top (car s)))
                  (set! s (cdr s))
                  (set! current-depth (- current-depth 1))
                  top)))
       (define (initialize)
         (set! s '())
         (set! number-pushes 0)
         (set! max-depth 0)
         (set! current-depth 0)
         'done)
       (define (print-statistics)
         (newline)
         (display (list 'total-pushes
                        '= number-pushes
                        'maximum-depth '= max-depth)))
       (define (dispatch message)
         (cond ((eq? message 'push) push)
               ((eq? message 'pop) (pop))
               ((eq? message 'initialize) (initialize))
               ((eq? message 'print-statistics)
                (print-statistics))
               (else (error "Unknown request: STACK" message))))
       dispatch))
(define (pop stack) (stack 'pop))
(define (push stack value) ((stack 'push) value))

(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
        (breakpoints '())
        (current-inst '()))
       (let ((the-ops
               (list
                 (list 'initialize-stack
                       (lambda () (stack 'initialize)))
                 (list 'print-stack-statistics
                       (lambda () (stack 'print-statistics)))))
             (register-table
               (list (list 'pc pc) (list 'flag flag))))
            (define (allocate-register name)
              (if (assoc name register-table)
                  (error "Multiply defined register: " name)
                  (set! register-table
                        (cons (list name (make-register name))
                              register-table)))
              'register-allocated)
            (define (lookup-register name)
              (let ((val (assoc name register-table)))
                   (if val
                       (cadr val)
                       (error "Unknown register:" name))))
            (define (set-breakpoint label line)
              (set! breakpoints (cons (make-breakpoint label line) breakpoints)))
            (define (cancel-breakpoint label line)
              (let ((new-breakpoints (filter
                                       (lambda (breakpoint)
                                               (or
                                                 (not (equal?
                                                        label
                                                        (get-label-from-breakpoint breakpoint)))
                                                 (not (equal?
                                                        line
                                                        (get-line-from-breakpoint breakpoint)))))
                                       breakpoints)))
                (set! breakpoints new-breakpoints)))
            (define (cancel-all-breakpoints)
              (set! breakpoints '()))
            (define (make-breakpoint label line)
              (cons label line))
            (define (get-label-from-breakpoint breakpoint)
              (car breakpoint))
            (define (get-line-from-breakpoint breakpoint)
              (cdr breakpoint))
            (define (breakpoint-set-for-inst? inst)
              ; inst has this form: (text proc meta-data)
              ; with meta-data as (label line)
              ; breakpoint has this form (label line)
              (define (breakpoint-set-iter breakpoints meta-data)
                (cond ((null? breakpoints) false)
                      ((and
                         (equal?
                           (get-label-from-meta-data meta-data)
                           (get-label-from-breakpoint (car breakpoints)))
                         (equal?
                           (get-line-from-meta-data meta-data)
                           (get-line-from-breakpoint (car breakpoints))))
                       true)
                      (else (breakpoint-set-iter (cdr breakpoints) meta-data))))
              (let ((meta-data (get-meta-data inst)))
                (breakpoint-set-iter breakpoints meta-data)))

            (define (execute)
              (let ((insts (get-contents pc)))
                   (if (null? insts)
                       'done
                       (let ((inst (car insts)))
                            (if (breakpoint-set-for-inst? inst)
                                (set! current-inst inst)
                                (begin
                                  ((instruction-execution-proc inst))
                                  (execute)))))))
            (define (cont-execution)
              ((instruction-execution-proc current-inst))
              (execute))
            (define (dispatch message)
              (cond ((eq? message 'start)
                     (set-contents! pc the-instruction-sequence)
                     (execute))
                    ((eq? message 'install-instruction-sequence)
                     (lambda (seq)
                             (set! the-instruction-sequence seq)))
                    ((eq? message 'allocate-register)
                     allocate-register)
                    ((eq? message 'get-register)
                     lookup-register)
                    ((eq? message 'install-operations)
                     (lambda (ops)
                             (set! the-ops (append the-ops ops))))
                    ((eq? message 'stack) stack)
                    ((eq? message 'operations) the-ops)
                    ((eq? message 'set-breakpoint) set-breakpoint)
                    ((eq? message 'cancel-breakpoint) cancel-breakpoint)
                    ((eq? message 'cancel-all-breakpoints) (cancel-all-breakpoints))
                    ((eq? message 'view-all-breakpoints) (display breakpoints))
                    ((eq? message 'cont-execution) (cont-execution))
                    (else (error "Unknown request: MACHINE"
                                 message))))
            dispatch)))
(define (start machine) (machine 'start))
(define (get-register-contents machine register-name)
  (get-contents (get-register machine register-name)))
(define (set-register-contents! machine register-name value)
  (set-contents! (get-register machine register-name)
                 value)
  'done)
(define (get-register machine reg-name)
  ((machine 'get-register) reg-name))
(define (set-breakpoint machine label line)
  ((machine 'set-breakpoint) label line))
(define (view-all-breakpoints machine)
  (machine 'view-all-breakpoints))
(define (proceed-machine machine)
  (machine 'cont-execution))
(define (cancel-breakpoint machine label line)
  ((machine 'cancel-breakpoint) label line))
(define (cancel-all-breakpoints machine)
  (machine 'cancel-all-breakpoints))

(define (assemble controller-text machine)
  (extract-labels
    controller-text
    (lambda (insts labels)
            (update-insts! insts labels machine)
            insts)))

(define (label-exists? labels label)
  (let ((val (assoc label labels)))
    (if val
      true
      false)))

(define (extract-labels text receive)
  (if (null? text)
      (receive '() '())
      (extract-labels
        (cdr text)
        (lambda (insts labels)
                (let ((next-inst (car text)))
                     (if (symbol? next-inst)
                       (if (label-exists? labels next-inst)
                         (error "Label existed: EXTRACT-LABLES" next-inst)
                         (begin
                           ; since insts is repeated inside each label
                           ; this can result in adding metadata to inst
                           ; multiple time, we need to test to check
                           ; if the metata exists
                           ; then we should not add it
                           (add-meta-data-to-insts! insts next-inst)
                           (receive insts
                                    (cons (make-label-entry next-inst
                                                            insts)
                                          labels))))
                         (receive (cons (make-instruction next-inst)
                                        insts)
                                  labels)))))))

(define (update-insts! insts labels machine)
  (let ((pc (get-register machine 'pc))
        (flag (get-register machine 'flag))
        (stack (machine 'stack))
        (ops (machine 'operations)))
       (for-each
         (lambda (inst)
                 (set-instruction-execution-proc!
                   inst
                   (make-execution-procedure
                     (instruction-text inst)
                     labels machine pc flag stack ops)))
         insts)))

; inst will have form (list text proc meta-data)
(define (make-instruction text) (list text '() '()))
(define (instruction-text inst) (car inst))
(define (instruction-execution-proc inst) (cadr inst))
(define (set-instruction-execution-proc! inst proc)
  (let ((meta-data (get-meta-data inst)))
       (set-cdr! inst (list proc meta-data))))
(define (get-meta-data inst)
  (caddr inst))
(define (add-meta-data-to-inst! inst meta-data)
  (if (null? (get-meta-data inst)) ; only add meta-data if not added already
      (set-cdr! (cdr inst) (list meta-data))))
(define (make-meta-data label count)
  (cons label count))
(define (get-label-from-meta-data meta-data)
  (car meta-data))
(define (get-line-from-meta-data meta-data)
  (cdr meta-data))

(define (add-meta-data-to-insts! insts label)
  (let ((count 1))
       (for-each (lambda (inst)
                         (let ((meta-data (make-meta-data label count)))
                              (add-meta-data-to-inst! inst meta-data)
                              (set! count (+ count 1))))
                 insts)))

(define (make-label-entry label-name insts)
  (cons label-name insts))
(define (lookup-label labels label-name)
  (let ((val (assoc label-name labels)))
       (if val
           (cdr val)
           (error "Undefined label: ASSEMBLE"
                  label-name))))

(define (make-execution-procedure
          inst labels machine pc flag stack ops)
  (cond ((eq? (car inst) 'assign)
         (make-assign inst machine labels ops pc))
        ((eq? (car inst) 'test)
         (make-test inst machine labels ops flag pc))
        ((eq? (car inst) 'branch)
         (make-branch inst machine labels flag pc))
        ((eq? (car inst) 'goto)
         (make-goto inst machine labels pc))
        ((eq? (car inst) 'save)
         (make-save inst machine stack pc))
        ((eq? (car inst) 'restore)
         (make-restore inst machine stack pc))
        ((eq? (car inst) 'perform)
         (make-perform inst machine labels ops pc))
        (else
          (error "Unknown instruction type: ASSEMBLE"
                 inst))))

(define (make-assign inst machine labels operations pc)
  (let ((target
          (get-register machine (assign-reg-name inst)))
        (value-exp (assign-value-exp inst)))
       (let ((value-proc
               (if (operation-exp? value-exp)
                   (make-operation-exp
                     value-exp machine labels operations)
                   (make-primitive-exp
                     (car value-exp) machine labels))))
            (lambda () ; execution procedure for assign
                    (set-contents! target (value-proc))
                    (advance-pc pc)))))
(define (assign-reg-name assign-instruction)
  (cadr assign-instruction))
(define (assign-value-exp assign-instruction)
  (cddr assign-instruction))

(define (advance-pc pc)
  (set-contents! pc (cdr (get-contents pc))))

(define (make-test inst machine labels operations flag pc)
  (let ((condition (test-condition inst)))
       (if (operation-exp? condition)
           (let ((condition-proc
                   (make-operation-exp
                     condition machine labels operations)))
                (lambda ()
                        (set-contents! flag (condition-proc))
                        (advance-pc pc)))
           (error "Bad TEST instruction: ASSEMBLE" inst))))
(define (test-condition test-instruction)
  (cdr test-instruction))

(define (make-branch inst machine labels flag pc)
  (let ((dest (branch-dest inst)))
       (if (label-exp? dest)
           (let ((insts
                   (lookup-label
                     labels
                     (label-exp-label dest))))
                (lambda ()
                        (if (get-contents flag)
                            (set-contents! pc insts)
                            (advance-pc pc))))
           (error "Bad BRANCH instruction: ASSEMBLE" inst))))
(define (branch-dest branch-instruction)
  (cadr branch-instruction))

(define (make-goto inst machine labels pc)
  (let ((dest (goto-dest inst)))
       (cond ((label-exp? dest)
              (let ((insts (lookup-label
                             labels
                             (label-exp-label dest))))
                   (lambda () (set-contents! pc insts))))
             ((register-exp? dest)
              (let ((reg (get-register
                           machine
                           (register-exp-reg dest))))
                   (lambda ()
                           (set-contents! pc (get-contents reg)))))
             (else (error "Bad GOTO instruction: ASSEMBLE" inst)))))
(define (goto-dest goto-instruction)
  (cadr goto-instruction))

(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
       (lambda ()
               (push stack (get-contents reg))
               (advance-pc pc))))
(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
       (lambda ()
               (set-contents! reg (pop stack))
               (advance-pc pc))))
(define (stack-inst-reg-name stack-instruction)
  (cadr stack-instruction))

(define (make-perform inst machine labels operations pc)
  (let ((action (perform-action inst)))
       (if (operation-exp? action)
           (let ((action-proc
                   (make-operation-exp
                     action machine labels operations)))
                (lambda () (action-proc) (advance-pc pc)))
           (error "Bad PERFORM instruction: ASSEMBLE" inst))))
(define (perform-action inst) (cdr inst))

(define (make-primitive-exp exp machine labels)
  (cond ((constant-exp? exp)
         (let ((c (constant-exp-value exp)))
              (lambda () c)))
        ((label-exp? exp)
         (let ((insts (lookup-label
                        labels
                        (label-exp-label exp))))
              (lambda () insts)))
        ((register-exp? exp)
         (let ((r (get-register machine (register-exp-reg exp))))
              (lambda () (get-contents r))))
        (else (error "Unknown expression type: ASSEMBLE" exp))))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))
(define (register-exp? exp) (tagged-list? exp 'reg))
(define (register-exp-reg exp) (cadr exp))
(define (constant-exp? exp) (tagged-list? exp 'const))
(define (constant-exp-value exp) (cadr exp))
(define (label-exp? exp) (tagged-list? exp 'label))
(define (label-exp-label exp) (cadr exp))

(define (make-operation-exp exp machine labels operations)
  (let ((op (lookup-prim (operation-exp-op exp)
                         operations))
        (aprocs
          (map (lambda (e)
                       (if (label-exp? e)
                           (error "can't work with label: MAKE-OPERATION-EXP")
                           (make-primitive-exp e machine labels)))
               (operation-exp-operands exp))))
       (lambda ()
               (apply op (map (lambda (p) (p)) aprocs)))))
(define (operation-exp? exp)
  (and (pair? exp) (tagged-list? (car exp) 'op)))
(define (operation-exp-op operation-exp)
  (cadr (car operation-exp)))
(define (operation-exp-operands operation-exp)
  (cdr operation-exp))

(define (lookup-prim symbol operations)
  (let ((val (assoc symbol operations)))
       (if val
           (cadr val)
           (error "Unknown operation: ASSEMBLE"
                  symbol))))
