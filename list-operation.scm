(load "base.scm")

(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) (- n 1))))

(define (set-list-ref items n val)
  (if (= n 0)
      (set-car! items val)
      (set-list-ref (cdr items) (- n 1) val)))

(define (list-ax-ref items n)
  (cond ((null? items) '())
        ((= n 0) (list-ax-ref (cdr items) (- n 1)))
        (else (cons (car items) (list-ax-ref (cdr items) (- n 1))))))

(define (length items)
  (accumulate (lambda (x y) (+ 1 y)) 0 items))

(define (append list1 list2)
  (accumulate cons list2 list1))

(define (last-pair items)
  (list-ref items (- (length items) 1)))

(define (unshift items item)
  (cons item items))

; reverse procedure pseudocode
; if source empty
;   return target
; else
;   item = car source
;   new_target = unshift target item
;   repeat (cdr source) new_target

(define (reverse items)
  (define (reverse-iter source target)
    (if (null? source)
        target
        (let ((item (car source)))
          (reverse-iter (cdr source) (unshift target item)))))
  (reverse-iter items '()))

(define (deep-reverse items)
  (define (reverse-iter source target)
    (if (null? source)
        target
        (let ((item (car source)))
             (if (pair? item)
                 (reverse-iter (cdr source) (unshift target (reverse-iter item '())))
                 (reverse-iter (cdr source) (unshift target item))))))
  (reverse-iter items '()))

(define (push items item)
  (reverse (cons item (reverse items))))

(push (list 1 2 3) 4)

; fringe pseudocode
; if list
;   concat (recursion result)
; else
;   push target item

(define (fringe items)
  (define (fringe-iter source target)
    (if (null? source)
        target
        (let ((item (car source)))
             (if (pair? item)
                 (fringe-iter (cdr source) (append target (fringe-iter item '())))
                 (fringe-iter (cdr source) (push target item))))))
  (fringe-iter items '()))

; Better fringe (renamed to enumerate-tree)
; recursive is the natural way of dealing with tree
(define (enumerate-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (list tree))
        (else (append (enumerate-tree (car tree))
                      (enumerate-tree (cdr tree))))))

(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (fold-right op initial sequence)
  (accumulate op initial sequence))

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(define (map proc items)
  (accumulate (lambda (x y) (cons (proc x) y)) nil items))

(define (for-each-with-index proc items)
  (define (iter proc items current-index)
    (if (null? items)
        nil
        ((proc (car items) current-index)
         (cons (car items)
               (iter proc (cdr items) (+ current-index 1))))))
  (iter proc items 0))

(define seqs (list (list 1 2 3) (list 4 5 6)))
(define (cars seqs)
  (if (null? seqs)
      nil
      (cons (car (car seqs)) (cars (cdr seqs)))))

(define (cdrs seqs)
  (if (null? seqs)
      nil
      (cons (cdr (car seqs)) (cdrs (cdr seqs)))))

(define (accumulate-n op init seqs)
 (if (null? (car seqs))
    nil
    (cons (accumulate op init (cars seqs))
          (accumulate-n op init (cdrs seqs)))))

(define (count-leaves x)
  (accumulate + 0 (map (lambda (x) 1) (enumerate-tree x))))

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))
(enumerate-interval 2 7)

(define (sum items)
  (accumulate + 0 items))

(define (remove item sequence)
  (filter (lambda (x) (not (= x item)))
          sequence))

(define (permutations s)
  (if (null? s)
      (list nil)
      (flatmap (lambda (x)
                       (map (lambda (p) (cons x p))
                            (permutations (remove x s))))
               s)))

(define (include? items item same?)
  (any? items (lambda (x) (same? x item))))

(define (any? items predicate)
  (cond ((null? items) false)
        ((predicate (car items)) true)
        (else (any? (cdr items) predicate))))

(define (find-index items item)
  (define (iter sequence item currentIndex)
    (cond ((null? sequence) -1)
          ((equal? (car sequence) item) currentIndex)
          (else (iter (cdr sequence) item (+ currentIndex 1)))))
  (if (null? items)
      -1
      (iter items item 0)))

(define (slice items startIndex endIndex)
  (map
    (lambda (x) (list-ref items x))
    (enumerate-interval startIndex endIndex)))

(define (concat list1 list2)
  (define (iter list1 list2)
    (if (null? list1)
        list2
        (iter (cdr list1) (cons (car list1) list2))))
  (if (null? list1)
      list2
      (iter (reverse list1) list2)))

(define (append! x y)
  (set-cdr! (last-pair x) y)
  x)

(define (last-pair x)
  (if (null? (cdr x)) x (last-pair (cdr x))))

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define (remove-item-at-index items index)
  (cond ((null? items) '())
        ((eq? index 0) (cdr items))
        (else
          (cons
            (car items)
            (remove-item-at-index
              (cdr items)
              (- index 1))))))

(define (swap! a-list a-index b-index)
  (let ((a-element (list-ref a-list a-index))
        (b-element (list-ref a-list b-index)))
       (set-list-ref a-list a-index b-element)
       (set-list-ref a-list b-index a-element)))

; How to shuffle a list?
; Let's use Fisher-Yates algorithm
; To shuffle an array a of n elements (indices 0..n-1):
;   for i from n - 1 downto 1 do
;        j = random integer with 0 <= j <= i
;        exchange a[j] and a[i]

(define (shuffle a-list)
  (define (internal-shuffle the-list list-length)
    (if (= list-length 1)
        the-list
        (let ((selected-index (random list-length)))
             (swap! the-list selected-index (- list-length 1))
             (internal-shuffle the-list (- list-length 1)))))
  (internal-shuffle a-list (length a-list)))
