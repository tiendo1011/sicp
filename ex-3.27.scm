; Draw an environment diagram to analyze the computation of (memo-fib 3)
; I draw this using the draft paper.

; Explain why memo-fib computes the nth Fibonacci number in a number of steps proportional to n
; Because it memorizes the previous computation

; Would the scheme still work if we had simply defined memo-fib to be (memoize fib)
; No, since it doesn't call memo-fib for recursive call beneath the method
