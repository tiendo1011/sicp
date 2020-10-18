; Solutions from billthelizard
; https://billthelizard.blogspot.com/2011/06/sicp-242-243-n-queens-problem.html

; What I have learned?
; 1. A recursive procedure can produce many forms of processes, each has different time complexity
; The common process forms: iterative, recursive, tree
; How to we know which process that a recursive procedure produce?
; We can see how it calls itself:
; - If it calls itself one time: it will produce either iterative or recursive process
; - If it calls itself more than one time: it will produce tree process
; 2. Be careful with tree recursive process, it's time complexity grows exponentially, and will bite
; you hard, tree recursive process has teeth
