; Example 1
; process A acquired the lock for file A
; When it reads file A, it knows that it needs to access file B

; process B acquired the lock for file B
; When it reads file B, it knows that it needs to access file A

; Example 2 (databases)
; process A acquired the lock for record A, only to know that it needs record B

; process B acquired the lock for record B, only to know that it needs record A

