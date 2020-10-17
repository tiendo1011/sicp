; safe? pseudocode
; To be in common with matrix term (from Wiki)
; We'll set matrix m*n <=> m rows & n cols
; The point A(i, j) <=> a point at i-th row & j-th col
; We'll use 1-based-index since the ex seems to indicate so

; 1. find k-th position queen rows, cols, diagonals
; Flow of thought: queen at k-th positon has signature (i, k)
; 1.1. rows: board[i]
; 1.2. cols: map over board, then return the k location of each row
; => It seems we need each location to have its (i, j) info
; 1.3. diagonals: from the queen position, there are 2 diagonals
; upper-left-to-lower-right-diagonal and
; lower-left-to-upper-right-diagonal
; We need to find the starting position (to the left)
; of those 2 diagonals, and see how many steps in can move along
; these lines
; 1.3.1 find the starting point:
; 1.3.1.1 upper-left-to-lower-right-diagonal
; Imagine the position is a ball, we move it along the diagonal
; each step reduce row & col by 1 until we reach the board boder
; So the point A(i, j) will have the starting point as:
; movable rows: i, movable cols: j, movable steps = min(i, j)
; i' = i - movable_steps, j' = j - movable_steps
; The steps: Each move increase row & col by 1 until we reach the board border
; so the steps: min(m - i', n - j')
; 1.3.1.2 lower-left-to-upper-right-diagonal
; Same as above, but now
; each step increase row by 1 and reduce col by 1
; So the point A(i, j) will have the starting point as:
; movable rows: m - i, movable cols: j, movable steps = min(m - i, j)
; i' = i + movable_steps; j' = j - movable_steps
; The steps: Each move reduce row by 1 and increase col by 1 until we reach the board border
; so the steps: min(i', n - j')

; 2. Check against the rest of queens to see if any queen is in that list

(load "common.scm")
(load "list-operation.scm")

(define (matrix-row-ref matrix n)
  (if (= n 0)
      (car matrix)
      (matrix-row-ref (cdr matrix) (- n 1))))

(define (make-position i j)
  (cons i j))

(define (get-position-row position)
  (car position))

(define (get-position-col position)
  (cdr position))

(define (make-board m n based-index)
  (map
    (lambda (row) (map
                    (lambda (col) (make-position row col))
                    (enumerate-interval based-index n)))
    (enumerate-interval based-index m)))

(define (get-first-row board)
  (matrix-row-ref board 0))

(define (get-same-row-positions board position based-index)
  (matrix-row-ref board (- (get-position-row position) based-index)))

(define (get-same-col-positions board position based-index)
  (map (lambda (row) (list-ref row (- (get-position-col position) based-index))) board))

(define (get-board-top-row-index board based-index)
  (- (length board) (- 1 based-index)))

(define (get-board-top-col-index board based-index)
  (- (length (get-first-row board)) (- 1 based-index)))

(define (get-same-first-diagonal-positions board position based-index)
  (let* ((movable-steps (min (- (get-position-row position) based-index) (- (get-position-col position) based-index)))
        (starting-row (- (get-position-row position) movable-steps))
        (starting-col (- (get-position-col position) movable-steps))
        (steps (min
                 (- (get-board-top-row-index board based-index) starting-row)
                 (- (get-board-top-col-index board based-index) starting-col))))
    (map (lambda (x) (make-position (+ starting-row x) (+ starting-col x))) (enumerate-interval 0 steps))))

(define (get-same-second-diagonal-positions board position based-index)
  (let* ((movable-steps (min
                          (- (get-board-top-row-index board based-index) (get-position-row position))
                          (- (get-position-col position) based-index)))
        (starting-row (+ (get-position-row position) movable-steps))
        (starting-col (- (get-position-col position) movable-steps))
        (steps (min
                 (- starting-row based-index)
                 (- (get-board-top-col-index board based-index) starting-col))))
    (map (lambda (x) (make-position (- starting-row x) (+ starting-col x))) (enumerate-interval 0 steps))))

; abstraction barriers: position, board

; (get-same-row-positions board position)
; (get-same-col-positions board position)
; (get-same-first-diagonal-positions board position)
; (get-same-second-diagonal-positions board position)

(define (adjoin-position new-row k rest-of-queens)
  (push rest-of-queens (make-position new-row k)))

(define (get-position-at-location k positions)
  (list-ref positions (- k 1)))

(define (same? pos1 pos2)
  (and
    (= (get-position-row pos1) (get-position-row pos2))
    (= (get-position-col pos1) (get-position-col pos2))))

(define (get-positions-except-location k positions)
  (let ((k-position (get-position-at-location k positions)))
    (filter (lambda (pos) (not (same? pos k-position))) positions)))

(define empty-board nil)

(define (get-danger-positions board position based-index)
  (append
    (append
      (append
        (get-same-row-positions board position based-index)
        (get-same-col-positions board position based-index))
      (get-same-first-diagonal-positions board position based-index))
    (get-same-second-diagonal-positions board position based-index)))

(define board (make-board 8 8 1))

(define (safe? k positions)
  (let ((rest-of-queens (get-positions-except-location k positions))
        (danger-positions (get-danger-positions board (get-position-at-location k positions) 1)))
    (not (any? rest-of-queens (lambda (queen-pos) (include? danger-positions queen-pos same?))))))

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter
          (lambda (positions) (safe? k positions))
          (flatmap
            (lambda (rest-of-queens)
                    (map (lambda (new-row)
                                 (adjoin-position
                                   new-row k rest-of-queens))
                         (enumerate-interval 1 board-size)))
            (queen-cols (- k 1))))))
  (queen-cols board-size))

; (queens 8) will print 92 sets of positions combination
; We can extract each one by using simple list extracted
; I verified with the first 2 sets and it works correctly
(length (queens 8))
; (car (queens 8))
; (cadr (queens 8))
