(define (filtered-accumulate combiner null-value term a next b predicate)
  (if (> a b)
      null-value
      (combiner (if (predicate a)
                    (term a)
                    null-value)
         (filtered-accumulate combiner null-value term (next a) next b predicate))))
