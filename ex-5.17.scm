; The idea is that make-goto will also set-contents! of current-label
; so that when print the instruction tracing, we can use that information
; this way it also doesn't interfere with instruction counting
