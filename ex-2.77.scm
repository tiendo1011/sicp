(magnitude z)
; with z = (complex rectangular 3 4)
; (magnitude z) (apply-genertic 'magnitude z)
; it finds type is complex & op named is magnitude
; When it calls get, it gets magnitude op, then it calls magnitude again with z now
; has complex stripped off
; So the above will becomes:
; (magnitude z) with z is (rectangular 3 4)

; apply-generic invoked:
; First time with 'magnitude (complex rectangular 3 4)
; Second time with 'magitude (rectangular 3 4)
; With this, it gets the 'magnitude from rectagular package, which doesn't use apply-generic
; So 2 times

; 'magnitude itself
; 'magnitude inside rectangular package
