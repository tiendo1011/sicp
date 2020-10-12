(define (count-change amount coin-values) (cc amount coin-values))
; (define (cc amount kinds-of-coins)
;   (cond ((= amount 0) 1)
;   ((or (< amount 0) (= kinds-of-coins 0)) 0)
;   (else (+ (cc amount
;               (- kinds-of-coins 1))
;            (cc (- amount
;                 (first-denomination
;                   kinds-of-coins))
;                kinds-of-coins)))))
; (define (first-denomination kinds-of-coins)
;   (cond ((= kinds-of-coins 1) 1)
;         ((= kinds-of-coins 2) 5)
;         ((= kinds-of-coins 3) 10)
;         ((= kinds-of-coins 4) 25)
;         ((= kinds-of-coins 5) 50)))

(define (no-more? coin-values)
  (null? coin-values))

(define (except-first-denomination coin-values)
  (cdr coin-values))

(define (first-denomination coin-values)
  (list-ref coin-values 0))

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
          (+ (cc amount
                 (except-first-denomination
                   coin-values))
             (cc (- amount
                    (first-denomination
                      coin-values))
                 coin-values)))))

(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(count-change 100 us-coins) ; 292
(count-change 51 us-coins) ; 50
; Does the order of the list coin-values affect the answer produced by cc? No
; Why or why not?
; Because the assumption hold no matter the order
; It needs the order to remains between computation though.
; Assumption:
; The number of ways to change amount a using n kinds of coins equals
; • the number of ways to change amount a using all but the first kind of coin, plus
; • the number of ways to change amount a − d using all n kinds of coins, where d is the denomination of the first kind of coin.
