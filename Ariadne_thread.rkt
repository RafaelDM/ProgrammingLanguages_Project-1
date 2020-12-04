;Daniel Atilano
;Rafael Medina
;4/12/2020
;Final Project

#lang racket

;***** Find exits on the four outer walls and change them to 2
(define (newMaze maze)
    ;**** Replace 0 to 2 in our TopWall
    (define upM(read-maze maze))
    (cond[(index-of (car upM) "0") (list->file (changer upM (index-of (car upM) "0") 0 "2") maze)]); * Up
    ;**** Replace 0 to 2 in our bottomWall
    (define downM(read-maze maze))
    (cond[(index-of (last downM) "0") (list->file (changer downM (index-of (last downM) "0") (- (length downM) 1) "2") maze)]);** Down
    ;**** Replace 0 to 2 in our leftWall
    (define leftM(columnMaze maze))
    (cond[(index-of (car leftM) "0") (list->file (columnMaze (changeLeft maze)) maze)]);*** Left
    ;***** Replace 0 to 2 in our rightWall
    (define rightM(columnMaze maze))
    (cond[(index-of (last rightM) "0") (list->file (columnMaze (changeRight maze)) maze)]))

;helper for updating left column
(define (changeLeft maze)
    (define mazen(columnMaze maze))
    (list->file (changer mazen (index-of (car mazen) "0") 0 "2") maze)
    maze)
;helper for updating Right column
(define (changeRight maze)
(define mazen(columnMaze maze))
    (list->file (changer mazen (index-of (last mazen) "0") (- (length mazen) 1) "2") maze)
    maze)


;*******************- Read Maze *****************************************
;** Read our maze line by Rows
(define (read-maze filename)
    (define in (open-input-file filename))
        (let loop
            ([lines (read-line in 'any)]
            [maze empty]
            [size 0])
            (cond 
                [(eof-object? lines) maze] ;call function
                [else 
                    (loop (read-line in 'any) (append maze (for/list () (string-split lines " "))) (add1 size))])))
                    


;** Read our Maze by Columns
(define (columnMaze maze)
    (define columnList(read-maze maze))
    (for/list ((i (length (list-ref columnList 0))))
        (for/list ((il columnList))
            (list-ref il i))))

;*************************************************************************************************************-
;******************Output maze to file
(define (list->file lst path)
  (let loop ([clone lst] [out (open-output-file path #:exists 'replace)])
    (if (empty? clone)
        (close-output-port out)
        (begin
          (for ([i (in-range (length (first clone)))])
            (display (list-ref (first clone) i) out)
            (when (< (+ i 1) (length (first clone))) (display " " out)))
          (unless (empty? (rest clone)) (display "\n" out))
          (loop (rest clone) out)))))

;**********************************************************************************************-
;-------------------Functions to find entrance amonst the four outer walls
;----------------------------------------------------------------------
;Once the entrance is reached, change "2" to "3" so as not to interpret it as an exit. 
(define (SealEntrance maze)
    (cond
    [(index-of (car (columnMaze maze)) "2") (list->file (columnMaze (leftColumn maze)) "fMaze.txt")] ;** Left
    [(index-of (last (columnMaze maze)) "2") (list->file (columnMaze (rightColumn maze)) "fMaze.txt")] ;** Right
    [(index-of (last (read-maze maze)) "2") (list->file (changer (read-maze maze) (index-of (last (read-maze maze)) "2") (- (length (read-maze maze)) 1) "3") "fMaze.txt")] ;** Down
    [(index-of (car (read-maze maze)) "2") (list->file (changer (read-maze maze) (index-of (car (read-maze maze)) "2") 0 "3") "fMaze.txt")] ;** Up
    ))

;Then find the adjacent node.
;** if the entrance is on lowermost wall the adjacent node must be up; and viceversa
;** if the entrance is on leftmost wall the adjacent node must be right; and viceversa
(define (findStart maze)
    (define door (list))
    (cond 
    [(index-of (last (read-maze maze)) "3")(append door (list (index-of (last (read-maze maze)) "3")(- (length (read-maze maze)) 2)))] ;* Down
    [(index-of (car (read-maze maze)) "3")(append door (list  (index-of (car (read-maze maze)) "3") 1))] ;* Up
    [(index-of (last (columnMaze maze)) "3")(append door (list (- (length (columnMaze maze)) 2) (index-of (last (columnMaze maze)) "3")))] ;* Right
    [(index-of (car (columnMaze maze)) "3")(append door (list 1 (index-of (car (columnMaze maze)) "3")))] ;* Left
    ))

;subFuncton  for SealEntrancethat changes 2 to 3 on athe leftcolumns
(define (leftColumn maze)
    (list->file (changer (columnMaze maze) (index-of (car (columnMaze maze)) "2") 0 "3") "fMaze.txt")
    maze)
    
;subFunction for SealEntrance that changes 2 to 3 on the right column
(define (rightColumn maze)
    (list->file (changer (columnMaze maze) (index-of (last (columnMaze maze)) "2") (- (length (columnMaze maze)) 1) "3") "fMaze.txt")
    maze)

;print resultMaze to Output file
(define (OutMaze filename list)
(define out (open-output-file filename #:exists 'truncate))
        (let loop
            ([list list]
             [n 0])
            (cond 
                [(empty? list) (close-output-port out) n]
                [else 
                    (fprintf out "~a\n" (car list))
                    (loop (cdr list) (add1 n))])))


;get entrance coordinates in x and y 
(define(helper-dfs maze) 
    (define entrance(findStart maze))
    (define solver(dfs (read-maze maze) (car entrance) (last entrance)))
    solver)
    
;find alternative paths for the solution
(define (dfs maze x y)
    (let loop               ;loop that updates the maze with ∧ ∨ < > arrows for the solution path only
    ([resultMaze maze]
    [x x]
    [y y])
    (if (string=? (finder resultMaze x y) "2")
        (OutMaze "fMaze.txt" resultMaze)
        (begin          
        (cond [(or (string=? (finder resultMaze (+ x 1) y) "0") (string=? (finder resultMaze (+ x 1) y) "2")) (loop (changer resultMaze x y ">") (+ x 1) y )])
        (cond [(or (string=? (finder resultMaze (- x 1) y) "0") (string=? (finder resultMaze (- x 1) y) "2")) (loop (changer resultMaze x y "<") (- x 1) y)])
        (cond [(or (string=? (finder resultMaze x (+ y 1)) "0") (string=? (finder resultMaze x (+ y 1)) "2")) (loop (changer resultMaze x y "∨") x (+ y 1))])
        (cond [(or (string=? (finder resultMaze x (- y 1)) "0") (string=? (finder resultMaze x (- y 1)) "2")) (loop (changer resultMaze x y "∧") x (- y 1))])
        ))))

;returns value given x and y indexes
(define(finder maze x y)
    (define findY(list-ref maze y))
    (list-ref findY x))

;generic function   
;returns updated list with arrow chars or 0 to 2 
(define (changer maze x y s)
    (define changeY(list-ref maze y))
    (define changeX(list-set changeY x s))
    (define resultMaze(list-set maze y changeX))
    resultMaze)

;function that runs the entire program
(define (main maze)
    (define copy(read-maze maze))
    (define ansMaze "fMaze.txt")
    (list->file copy ansMaze)
    (newMaze ansMaze)
    (newMaze ansMaze)
    (SealEntrance ansMaze)
    (helper-dfs ansMaze)
    (display "The answer is in 'fmaze.txt' "))