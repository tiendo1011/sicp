; The challenge comes from having to traverse back, from an item
; to the previous item in O(1) step
; turns out that we can "make" an item point to it's previous item

; Normally, a pair can only point to the next item in the list
; if we add a more elaborate pair: (('symbol '()) '())
; so we can make the inner cdr point to its previous item

; Let's start with an example
; Start with an empty value: '()
; We want to insert to front, let's say, a symbol 'a
; node-1: (('a '()) '())
; insert it: (('a '()) '()) '()

; We want to insert another one, let's say, a symbol 'b
; node-2: (('b '()) '())
; insert it: (('b '()) '()) (('a '()) '()) '()
; then we can set node-1 cdar to node-2, to create a portal for it to traverse to its previous item

; Let's implement it:

(define (empty-deque? deque)
  (null? deque))

(define (front-insert-deque! deque item)
  (let ((new-pair (cons (cons item '()) '())))
    (if (empty-deque? deque)
        new-pair
        (begin (set-cdr! (car deque) new-pair) (set-cdr! new-pair deque) deque))))

; Let's try rear insert
; Start with an empty value: '()
; We want to insert to rear, let's say, a symbol 'a
; node-1: (('a '()) '())
; insert it: (('a '()) '()) '()

; We want to insert another one, let's say, a symbol 'b
; node-2: (('b '()) '())
; To insert (('b '()) '()) to (('a '()) '()) '() is pretty awkward
; It's better if we have a front & rear pointer
; For example, after the first rear insert, front & rear pointer both point to (('a '()) '())
; To insert ('b '()), we can set (cdr rear pointer to ('b '()) '()), and set cdar node-2 to a

; (define (rear-insert-deque! deque item)
;   (let ((new-deque (cons deque (cons item '()))))
;     (if (empty-deque? deque)
;         new-deque
;         (begin (set-cdr! (car deque) new-deque) new-deque))))

; Let's apply it to create a deque
(define (front-ptr deque) (car deque))
(define (rear-ptr deque) (cdr deque))
(define (set-front-ptr! deque item)
  (set-car! deque item))
(define (set-rear-ptr! deque item)
  (set-cdr! deque item))
(define (empty-deque? deque)
  (null? (front-ptr deque)))
(define (make-deque) (cons '() '()))
(define (front-deque deque)
  (if (empty-deque? deque)
      (error "FRONT called with an empty deque" deque)
      (car (front-ptr deque))))
(define (front-insert-deque! deque item)
  (let ((new-pair (cons (cons item '()) '())))
       (cond ((empty-deque? deque)
              (set-front-ptr! deque new-pair)
              (set-rear-ptr! deque new-pair)
              deque)
             (else
               (set-cdr! (car (front-ptr deque)) new-pair)
               (set-cdr! new-pair (front-ptr deque))
               (set-front-ptr! deque new-pair)
               deque))))

(define (rear-insert-deque! deque item)
  (let ((new-pair (cons (cons item '()) '())))
       (cond ((empty-deque? deque)
              (set-front-ptr! deque new-pair)
              (set-rear-ptr! deque new-pair)
              deque)
             (else
               (set-cdr! (car new-pair) (rear-ptr deque))
               (set-cdr! (rear-ptr deque) new-pair)
               (set-rear-ptr! deque new-pair)
               deque))))

(define (front-delete-deque! deque)
  (cond ((empty-deque? deque)
         (error "FRONT-DELETE! called with an empty deque" deque))
        (else
          (set-front-ptr! deque (cdr (front-ptr deque)))
          (set-cdr! (car (front-ptr deque)) '())
          deque)))

(define (rear-delete-deque! deque)
  (cond ((empty-deque? deque)
         (error "REAR-DELETE! called with an empty deque" deque))
        (else
          (let ((previous-item (cdar (rear-ptr deque))))
            (if (null? previous-item)
                (set-front-ptr! deque '())
                (begin
                  (set-rear-ptr! deque previous-item)
                  (set-cdr! previous-item '())))
            deque))))

(define (print-deque deque)
  (define (print-list list)
    (if (not (null? list))
        (begin
          (display (caar list))
          (print-list (cdr list)))))
  (print-list (front-ptr deque)))
