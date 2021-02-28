; Exercise 2.42 described the “eight-queens puzzle” of placing queens
; on a chessboard so that no two attack each other.
; Write a nondeterministic program to solve this puzzle.

; The idea:
; Place the first queen on the first col (Using amb)
; Place the second queen on the second col (Using amb)
; Require the new queen to be safe, compare to the last queen position
; Place the third queen on the third col (Using amb)
; Require the new queen to be safe, compare to the 2 last queen positions
; Continue until we hit the 8-th column
; We can re-use the safe? procedure from Ex-2.42
