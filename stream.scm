; DrRacket already provide cons-stream, delay & force operation

; I noted the implementation in the book here for reference
; (define (cons-stream a b) (cons a (delay b)))
; (define (delay exp) (lambda () exp))
; (define (force delayed-object) (delayed-object))

(define (stream-car s) (car s))
(define (stream-cdr s) (force (cdr s)))

(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
        low
        (stream-enumerate-interval (+ low 1) high))))

(define (m-stream-append s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (m-stream-append (stream-cdr s1) s2))))

(define (stream-map proc s)
  (if (stream-null? s)
      the-empty-stream
      (cons-stream (proc (stream-car s))
                   (stream-map proc (stream-cdr s)))))

(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map (lambda (stream) (stream-car stream)) argstreams))
       (apply stream-map
              (cons proc (map (lambda (stream) (stream-cdr stream)) argstreams))))))

(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
                      (stream-filter
                        pred
                        (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))

(define (stream-for-each proc s)
  (if (stream-null? s)
      'done
      (begin (proc (stream-car s))
             (stream-for-each proc (stream-cdr s)))))

(define (display-stream s)
  (stream-for-each display-line s))
(define (display-line x) (newline) (display x))

(define (add-streams s1 s2) (stream-map + s1 s2))

(define (mul-streams s1 s2) (stream-map * s1 s2))

(define (div-streams s1 s2) (stream-map / s1 s2))

(define (scale-stream stream factor)
(stream-map (lambda (x) (* x factor))
stream))

(define (partial-sums s)
  (define s-partial-sums-stream
    (cons-stream (stream-car s) (add-streams s-partial-sums-stream (stream-cdr s))))
  s-partial-sums-stream)

(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))
(define integers (integers-starting-from 1))

(define (display-stream-with-limit stream limit)
  (if (> limit 0)
      (begin
        (display (stream-car stream))
        (display " ")
        (display-stream-with-limit (stream-cdr stream) (- limit 1)))))

(define (merge s1 s2)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
          (let ((s1car (stream-car s1))
                (s2car (stream-car s2)))
               (cond ((< s1car s2car)
                      (cons-stream
                        s1car
                        (merge (stream-cdr s1) s2)))
                     ((> s1car s2car)
                      (cons-stream
                        s2car
                        (merge s1 (stream-cdr s2))))
                     (else
                       (cons-stream
                         s1car
                         (merge (stream-cdr s1)
                                (stream-cdr s2)))))))))

(define (memo-proc proc)
  (let ((already-run? false) (result false))
       (lambda ()
               (if (not already-run?)
                   (begin (set! result (proc))
                          (set! already-run? true)
                          result)
                   result))))

; equals to
(define memo-proc (lambda (proc)
  ((lambda (already-run? result)
       (lambda () ; (1)
               (if (not already-run?)
                   (begin (set! result (proc))
                          (set! already-run? true)
                          result)
                   result))) false false)))

; (delay exp)
; is equals to
(memo-proc (lambda () exp))
; What does memo-proc calls returns?
; a procedure object, which is the result of evaluating lambda at (1)
; this procedure object has access to already-run? & result

; What happens when you force it?
; you evaluate the procedure object, which triggers the evaluation of the body
; which set already-run? to true, result to the result of exp
; If you force it again, it'll return the result without evaluating the exp
