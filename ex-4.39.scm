; I think the order doesn't matter
; since all result has to run through the same filters
; to be accepted as the answer

; What about the time?
; The time it takes is corresponding to the number of operations it has to run
; Let's analyze it in 2 scenarios: best case & worst case
; 1. In best case scenario:
; the first combination is correct, and it goes through all the checks
; which takes the same time no matter the order

; 2. In worst case scenario:
; All combinations give the wrong answer until the last one
; but the number of operations might be different
; There are 2 factors at play here:
; - The number of combinations that pass a certain requirement
; - The time complexity of the requirement
; Since only distinct? has different time complexity, we can remove it out
; from the picture to simplify out thought process
; Let's check the 4 filters in between:
; 1. not (baker = 5)
; 2. not (cooper = 1)
; 3. not (fletcher = 5)
; 4. not (fletcher = 1)
; There are 120 (5!) combinations that passed distinct? calls and fetch to these 4 filters
; in these 120 combinations, 24 (4!) of them has baker = 5
; which fails the 1. test
; So 96 combinations is fetched to 2.
; How many pass?
; To pass, the combinations has to satisfy both (not baker = 5) && (not cooper = 1)
; (not cooper = 1) && (not baker = 5) = 120 - (baker = 5 or cooper = 1)
; Apply inclusion-exclusion principle, we have
; (baker = 5 or cooper = 1) = (baker = 5) + (cooper = 1) - (baker = 5 and cooper = 1)
;                           = 24 + 24 - 3! = 42
; So (not cooper = 1) && (not baker = 5) = 120 - 42 = 78
; So 78 combinations is fetched to 3.
; How many pass?
; To pass, the combinations has to satisfy (not baker = 5) && (not cooper = 1) && (not fletcher = 5)
; (not baker = 5) && (not cooper = 1) && (not fletcher = 5) = 120 - (baker = 5 or cooper = 1 or fletcher = 5)
; Apply inclusion-exclusion principle, we have
; (baker = 5 or cooper = 1 or fletcher = 5)
; = (baker = 5) + (cooper = 1) + (fletcher = 5)
;   - (baker = 5 and cooper = 1) - (cooper = 1 and fletcher = 5) - (fletcher = 5 and baker = 5)
;   + (baker = 5 and cooper = 1 and fletcher = 5)
; = 24 + 24 + 24 - 3! - 3! - 0 + 0 = 60
; So (not baker = 5) && (not cooper = 1) && (not fletcher = 5) = 120 - 60 = 60
; So 60 combinations is fetched to 4.
; How many pass?
; To pass, the combinations has to satisfy (not baker = 5) && (not cooper = 1) && (not fletcher = 5) && (not fletcher = 1)
; (not baker = 5) && (not cooper = 1) && (not fletcher = 5) && (not fletcher = 1) = 120 - (baker = 5 or cooper = 1 or fletcher = 5 or fletcher = 1)
; Apply inclusion-exclusion principle, we have
; (baker = 5 or cooper = 1 or fletcher = 5 or fletcher = 1)
; = (baker = 5) + (cooper = 1) + (fletcher = 5) + (fletcher = 1)
;   - (baker = 5 and cooper = 1) - (baker = 5 and fletcher = 5) - (baker = 5 and fletcher = 1)
;   - (cooper = 1 and fletcher = 5) - (cooper = 1 and fletcher = 1) - (fletcher = 1 and fletcher = 5)
;   + (baker = 5 and cooper = 1 and fletcher = 5)
;   + (baker = 5 and cooper = 1 and fletcher = 1)
;   + (baker = 5 and fletcher = 5 and fletcher = 1)
;   + (cooper = 1 and fletcher = 5 and fletcher = 1)
;   - (baker = 5 and cooper = 1 and fletcher = 5 and fletcher = 1)
; = 24 + 24 + 24 + 24 - 3! - 0 - 3! - 3! - 0 + 0 + 0 + 0 + 0 = 78
; So (not baker = 5) && (not cooper = 1) && (not fletcher = 5) && (not fletcher = 1) = 120 - 78 = 42
; So 42 combinations is fetched to the require after 4.
; So in total, 120 + 96 + 78 + 60 = 354 operations runs before 42 combinations can be fetched to the require after 4.

; Let's change the order to see if the operations run becomes different:
; 1. not (fletcher = 5)
; 2. not (fletcher = 1)
; 3. not (baker = 5)
; 4. not (cooper = 1)
; There are 120 (5!) combinations that passed distinct? calls and fetch to these 4 filters
; in these 120 combinations, 24 (4!) of them has fletcher = 5
; which fails the 1. test
; So 96 combinations is fetched to 2.
; How many pass?
; To pass, the combinations has to satisfy both (not fletcher = 5) && (not fletcher = 1)
; (not fletcher = 5) && (not fletcher = 1) = 120 - (fletcher = 5 or fletcher = 1)
; Apply inclusion-exclusion principle, we have
; (fletcher = 5 or fletcher = 1)
; = (fletcher = 5) + (fletcher = 1) - (fletcher = 5 and fletcher = 1)
; = 24 + 24 - 0 = 48
; So (not fletcher = 5) && (not fletcher = 1) = 120 - 48 = 72
; So 72 combinations is fetched to 3.
; How many pass?
; To pass, the combinations has to satisfy both (not fletcher = 5) && (not fletcher = 1) && (not baker = 5)
; (not fletcher = 5) && (not fletcher = 1) && (not baker = 5) = 120 - (fletcher = 5 or fletcher = 1 or baker = 5)
; Apply inclusion-exclusion principle, we have
; (fletcher = 5 or fletcher = 1 or baker = 5)
; = (fletcher = 5) + (fletcher = 1) + (baker = 5)
;   - (fletcher = 5 and fletcher = 1) - (fletcher = 5 and baker = 5) - (fletcher = 1 and baker = 5)
;   + (fletcher = 5 and fletcher = 1 and baker = 5)
; = 24 + 24 + 24 - 0 - 0 - 3! + 0 = 66
; So (not fletcher = 5) && (not fletcher = 1) && (not baker = 5) = 120 - 66 = 54
; So 54 combinations is fetched to 4.
; How many pass?
; To pass, the combinations has to satisfy (not baker = 5) && (not cooper = 1) && (not fletcher = 5) && (not fletcher = 1)
; Which is calculated above, which is 42
; So 42 combinations is fetched to the require after 4.
; So in total, 120 + 96 + 72 + 54 = 342 operations runs before 42 combinations can be fetched to the require after 4.
; Since 342 < 354, it runs faster

(define (multiple-dwelling)
  (let ((baker
          (amb 1 2 3 4 5)) (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5)) (miller (amb 1 2 3 4 5))
        (smith
          (amb 1 2 3 4 5)))
       (require
         (distinct? (list baker cooper fletcher miller smith)))
       (require (not (= baker 5)))
       (require (not (= cooper 1)))
       (require (not (= fletcher 5)))
       (require (not (= fletcher 1)))
       (require (> miller cooper))
       (require (not (= (abs (- smith fletcher)) 1)))
       (require (not (= (abs (- fletcher cooper)) 1)))
       (list (list 'baker baker)
             (list 'cooper cooper)
             (list 'fletcher fletcher) (list 'miller miller)
             (list 'smith smith))))
