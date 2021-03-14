(assert! (married Minnie Mickey))
(assert! (rule (married ?x ?y) (married ?y ?x)))
(married Mickey ?who)

; Describe what kind of information (patterns and frames) is included in
; this history, and how the check should be made.

; The history should know the instantiated version of the query
; For example, in the above case, it's (married Mickey ?who)
