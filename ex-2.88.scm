; Add it directly to generic-arithmetic-operations.scm
; One note: At first I tried to use sub-terms to negate
; The idea is we can sub-terms 0 terms-to-negate
; But because sub-terms calls negate, and negate calls sub-terms
; can easily lead to infinite loop
; So I changed by negate all of its terms, same for scheme-number, rational, complex number
