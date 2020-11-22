Exercise in the book "Structure and Interpretation of Computer Programs, 2nd ed"

Initially I used repl.it, nice experience at the beginning,
but as I move along with the book, repl.it's interpreter lacks some procedure mentioned in the
book ((runtime), for eg). So I moved to run the code on my local machine.

Setup follow the instruction here:
https://crash.net.nz/posts/2014/08/configuring-vim-for-sicp/
Only one difference, I use this version of tslime instead of the one
mentioned in the post: https://github.com/jgdavey/tslime.vim

What I have learned so far:
- Abstraction barrier is important, it allows you to focus on one level at the time.
- Recursive procedure forms different process form, either linear
iteractive, linear recursive, or tree recursive. Focus on how many
times it calls itself at each iteration will tell you which form it'll
produce when run. A good exercise help me understand it is Ex-2.43
- Although the number of calls a procedure makes to itself will form the
procedure shape, the time complexity also depends on the number of
elements we feed to the call after each step. A good exercise help me
understand this is Ex-2.63b
- Master theorem is a good way to determine run time complexity of
recursive call.
With T(n) = aT(n/b) + f(n)
If n^(logb(a)) and f(n) has polynomial difference then it falls into 3
cases:
1. Work to split/recombine a problem is dwarfed by subproblems.
2. Work to split/recombine a problem is comparable to subproblems.
3. Work to split/recombine a problem dominates subproblems.
Which determine its run time complexity (more in
[wiki](https://en.wikipedia.org/wiki/Master_theorem_(analysis_of_algorithms)))
- To log effectively, you need to be clear about what you want to know first
