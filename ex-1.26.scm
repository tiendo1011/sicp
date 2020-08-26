; The different between square(expmod base n m)
; and * (expmod base n m) (expmod base n m)

; square(expmod base n m)
; (Let's assume it takes a steps)
; Double the size of the input only add one more step:
; square(expmod base 2n m) => square(square(expmod base n m)) => a + 1 steps

; * (expmod base n m) (expmod base n m)
; Lets assume they take a steps
; Double the size of the input
;    * (expmod base 2n m) (expmod base 2n m)
; => * (* (expmod base n m) (expmod base n m)) (* (expmod base n m) (expmod base n m))
; => Each * (expmod base n m) (expmod base n m) takes a steps
; => We have to calculate them twice so they take 2a steps
; => That's O(n) growth
