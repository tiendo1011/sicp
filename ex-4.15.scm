(try try)
=>
(if (halts? try try) (run-forever) 'halted)

; If (halts? try try) returns true, then it runs forever
; so (try try) actually run forever (while (halts try try) tells us that it'll be halted)

; If (halts? try try) returns false, then it's halted
; so (try try) actually halted, (while (halts try try) tells us that it'll run forever)
