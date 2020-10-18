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
