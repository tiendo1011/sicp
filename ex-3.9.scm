1. recursive version:
1.1 global env: factorial -> (param n, body ...), enclosing env: no
1.2 (factorial 6) creates a new env, and binds n to 6, and evaluate the body
(the enclosing env is global env, where factorial is defined)
if (= 6 1) 1 (* 6 (factorial 5))
<=> (* 6 (factorial 5))
1.3 (factorial 5) creates a new env, and binds n to 5, and evaluate the body:
(the enclosing env is global env, where factorial is defined)
if (= 5 1) 1 (* 5 (factorial 4))
...
1.7 (factorial 1) creates a new env, and binds n to 1, and evaluate the body:
(the enclosing env is global env, where factorial is defined)
if (= 1 1) 1 (No new env is created)

2. iterative version
1.1 global env:
factorial -> (param n, body ...), enclosing env: no
fact-iter -> (param product, counter, max-count, body ...), enclosing env: no
1.2 (factorial 6) creates a new env, binds n to 6, and evaluate the body
(the enclosing env is global env, where factorial is defined)
(fact-iter 1 1 6) (fact-iter is found in the enclosing env)
1.3 (fact-iter 1 1 6) creates a new env, binds product to 1, counter to 1, max-count to 6, and evaluate the body
(the enclosing env is global env, where fact-iter is defined)
(if (> 1 6)
    1
    (fact-iter 1 2 6))
<=> (fact-iter 1 2 6)
1.4 (fact-iter 1 2 6) creates a new env, binds product to 1, counter to 2, max-count to 6, and evaluate the body
(the enclosing env is global env, where fact-iter is defined)
1.5 (fact-iter 2 3 6)
1.6 (fact-iter 6 4 6)
1.7 (fact-iter 24 5 6)
1.8 (fact-iter 120 6 6)
1.9 (fact-iter 720 7 6)
