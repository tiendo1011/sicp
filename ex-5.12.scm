; a. a list of all instructions, with duplicates removed, sorted by instruction type (assign, goto, and so on);
; => From ex-5.8.scm
; the extract-labels returns this:
; insts:
((goto (label here))
 (assign a (const 3))
 (goto (label there))
 (assign a (const 4))
 (goto (label there))
 ())

; so the problem is to process this list to:
; - remove duplicates
; - sort by instruction type
; to implement it, we can: sort it, then check 2 consercutive element & remove one if they're duplicated
; to aid the sort, we might consider squash all the symbol into one (you can call it a SHA representation
; of the original operation)
; so (goto (label here)) -> (gotolabelhere)
; then use that SHA to sort & remove duplicates

; b. a list (without duplicates) of the registers used to hold
; entry points (these are the registers referenced by goto instructions)
; => After we have done part a, this part is pretty easy, just extract the label from the goto operation

; c. a list (without duplicates) of the registers that are saved or restored;
; => just extract from (save) & (restore) operation

; d. for each register, a list (without duplicates) of the sources
; from which it is assigned (for example, the sources for
; register val in the factorial machine of Figure 5.11 are
; (const 1) and ((op *) (reg n) (reg val)))
; => this is also easy, just extract from assign operations
