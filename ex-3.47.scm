; The original implementation
(define (make-serializer)
  (let ((mutex (make-mutex)))
       (lambda (p)
               (define (serialized-p . args)
                 (mutex 'acquire)
                 (let ((val (apply p args)))
                      (mutex 'release)
                      val))
               serialized-p)))

(define (make-mutex)
  (let ((cell (list false)))
       (define (the-mutex m)
         (cond ((eq? m 'acquire)
                (if (test-and-set! cell)
                    (the-mutex 'acquire)))
               ((eq? m 'release) (clear! cell))))
       the-mutex))
(define (clear! cell) (set-car! cell false))

(define (test-and-set! cell)
  (without-interrupts
    (lambda ()
            (if (car cell)
                true
                (begin (set-car! cell true)
                       false)))))

; a. in terms of mutexes:
; It uses mutex to protect access to count
(define (make-semaphore n)
  (let ((count n)
        (mutex (make-mutex)))
       (define (the-semaphore m)
         (cond ((eq? m 'acquire)
                (mutex 'acquire)
                (if (zero? count)
                    (begin (mutex 'release) (the-semaphore 'acquire))
                    (begin (set! count (- count 1) (mutex 'release)))))
               ((eq? m 'release)
                (mutex 'acquire)
                (begin (set! count (+ count 1)) (mutex 'release)))))
       the-semaphore))

; b. in terms of atomic test-and-set! operations
; It uses test-and-set! to protect access to count
(define (make-semaphore n)
  (let ((count n)
        (cell (list false)))
       (define (the-semaphore m)
         (cond ((eq? m 'acquire)
                (if (test-and-set! cell)
                    (the-semaphore 'acquire)
                    (begin
                      (if (zero? count)
                          (begin (clear! cell) (the-semaphore 'acquire))
                          (begin (set! count (- count 1)) (clear! cell))))))
               ((eq? m 'release)
                (if (test-and-set! cell)
                    (the-semaphore 'release)
                    (begin (set! count (+ count 1)) (clear! cell))))))
       the-mutex))
