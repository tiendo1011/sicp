; 1. generic operations with explicit dispatch
; sample
(define (real-part z)
  (cond ((rectangular? z)
         (real-part-rectangular (contents z)))
        ((polar? z)
         (real-part-polar (contents z)))
        (else (error "Unknown type: REAL-PART" z))))
; 2. data-directed style
; sample
(define (real-part z) (apply-generic 'real-part z))
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
       (let ((proc (get op type-tags))) ; get operation & type-tags from table
            (if proc
                (apply proc (map contents args))
                (error
                  "No method for these types: APPLY-GENERIC"
                  (list op type-tags))))))
; 3. message-passing style
(define (make-from-real-imag x y)
  (define (dispatch op)
    (cond ((eq? op 'real-part) x)
          ((eq? op 'imag-part) y)
          ((eq? op 'magnitude) (sqrt (+ (square x) (square y))))
          ((eq? op 'angle) (atan y x))
          (else (error "Unknown op: MAKE-FROM-REAL-IMAG" op))))
  dispatch)
(define (apply-generic op arg) (arg op))

; Assumption: System with lots of operations, lots of type
; Case 1: Add new type
;   1. Generic operations with explicit dispatch
;     Add new operation, add code to detect newtype
;     Change all the generic operations to dispatch the new type to the correct method
;     new type must not collide with old type
;     => Changes in many places
;   2. data-directed style
;     install a new package that handles the new type (might have a lot of old operations)
;     => Changes in one place
;   3. message-passing style
;     Add new data object that can handle all old operations (might have a lot of old operations)
;     => Changes in one place

; Case 2: Add new operation
;   1. Generic operations with explicit dispatch
;     The new operation needs to aware of all the old types
;     => Changes in one place
;   2. data-directed style
;     install a new operation in all old packages
;     => Changes in many places
;   3. message-passing style
;     Add new operation to all the data object
;     => Changes in many places

; For a system in which:
;  - new types must often be added: data-directed style or message-passing style
;  - new operations must often be added: Generic operations with explicit dispatch
