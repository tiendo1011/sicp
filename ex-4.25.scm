; Since we needs the arguments before we enter unless body
; it'll run forever
; (factorial 5)
; will evaluate (* 5 (factorial 4))
; (factorial 4)
; will evaluate (* 4 (factorial 3))
; ...
; and never stops

; Will our definitions work in a normal-order language?
; Yes
