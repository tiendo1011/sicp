(load "power-series.scm")
(load "ex-3.59.scm")

; div-series is defined inside power-series.scm
(define tangent-series (div-series sine-series cosine-series))

(stream-ref tangent-series 0); 0
(stream-ref tangent-series 1); 1
(stream-ref tangent-series 2); 0
(stream-ref tangent-series 3); 1/3
(stream-ref tangent-series 4); 0
(stream-ref tangent-series 5); 2/15

; The result is the same as the tan(x) power series here:
; https://proofwiki.org/wiki/Power_Series_Expansion_for_Tangent_Function
