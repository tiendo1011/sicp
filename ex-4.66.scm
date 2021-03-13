; Let's say we wanna calculate this:
(sum ?amount (and (wheel ?who)
                  (salary ?who ?amount)))

; Since (wheel ?who) will return (Warbucks Oliver) four times
; sum will calculate its salary four times

; To salvage the situation, he might need to distinct the value
; he gets from the frames so that one variable only has one version
; of value?
; => This might not be correct, since it's possible that 2 people
; has the same salary

; Another solution is to change rule implementable so that it can
; filter out the duplicate result frames?
