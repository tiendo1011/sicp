; We wanna use default map operation
; Not the one we define, so we can't load list-operation.scm
; Hence we copy accumulate here
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

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

(define (dot-product v w)
 (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
  (map (lambda (x) (dot-product x v)) m))

(define (transpose mat)
  (accumulate-n cons nil mat))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (x) (matrix-*-vector cols x)) m)))
