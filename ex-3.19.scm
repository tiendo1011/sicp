; It seems like the solution in 3.18 already solved the 3.19
; For all list, the algorithm only need to keep one pointer to
; the cdr of x
; The last-pair procedure doesn't need to remember anything so
; it doesn't take up any memory
; After searching the internet, I find that the algorithm only
; works if the cycle start from the begining, which is:
; a -> b -> c -> a (1)

; It doesn't work for a cycle start after the beginning, like:
; a -> b -> c -> b

; Also, since the ex 3.18 mentioned that ex 3.13 constructed a sample
; cycle list (which only creates a cycle with form as (1))
; So the line of reasoning is acceptable
; Also, the Floyd cycle detection algorithm is pretty cool, though
; More info: https://dev.to/alisabaj/floyd-s-tortoise-and-hare-algorithm-finding-a-cycle-in-a-linked-list-39af
; (One note, though, I think the hare should start at the beginning, just like
; the tortoise)
; The hare will never jump over the tortoise because:
; https://stackoverflow.com/a/5834373/4632735
