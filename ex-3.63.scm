(define (sqrt-stream x) ; (1)
  (define guesses
    (cons-stream
      1.0
      (stream-map (lambda (guess) (sqrt-improve guess x))
                  guesses)))
  guesses)

(define (sqrt-stream x) ; (2)
  (cons-stream 1.0 (stream-map
                     (lambda (guess)
                             (sqrt-improve guess x))
                     (sqrt-stream x))))

; To know how it performs redundant computation
; We need to know how it computes its sequence items
; Then we can see how it's redundant

; Let's try first version:
; 1st item: 1.0
; 2nd item: execute stream-map, with gets guess from guesses stream (which is the first item)
; x from the environment where the procedure is defined, which is when we called (sqrt-stream 1.0)
; 3rd item: execute with the next guess from the stream
; 4rd item: execute with the next guess from the stream

; Let's try the second version:
; 1st item: 1.0
; 2nd item: execute stream-map, which gets guess from (sqrt-stream x) stream
; but it has to execute (sqrt-stream x) first, which returns (cons-stream 1.0 (stream-map ..))
; the first item is 1.0, so it uses that
; 3rd item: (stream-map of the second item of the return result from the call to (sqrt-stream x))
; but the computation to produce the second item is memorized, so it's not that inefficient?
; to memorize, (sqrt-stream x) in the 2 calls has to be the same sequence,
; I don't feel like they're, since they're executed in different environment

; Would the two versions still differ in efficiency if our implementation of delay
; used only (lambda () ⟨ exp ⟩ ) without using the optimization provided by memo-proc?
; Without memo-proc?, version (1) suffers
; To get to the 3rd item, it needs to recalculate the second item
; so it's the same
