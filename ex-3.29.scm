; o-> apply or circuit
; a-> apply and circuit
; i-> apply inverter circuit

; desired or circuit output:
; 1 + 1 -o-> 1
; 1 + 0 -o-> 1
; 0 + 1 -o-> 1
; 0 + 0 -o-> 0

; Flow: apply inverter to inputs, apply and circuit to them, and inverter output
; 0 + 0 -a-> 0 -i-> 1
; 0 + 1 -a-> 0 -i-> 1
; 1 + 0 -a-> 0 -i-> 1
; 1 + 1 -a-> 1 -i-> 0

; Delay time: 2 inverter-delay + and-gate-delay + inverter-delay = 3 inverter-delay + and-gate-delay
