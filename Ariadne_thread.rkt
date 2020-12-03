;Daniel Atilano
;Rafael Medina
;4/12/2020
;Final Project

#lang racket


;***** Change Lines of the list of lists to new lines with 2 as exits
(define (newMaze maze)
    (define upperMaze (append (list (findUpper maze))(remove (car (read-maze maze)) (read-maze maze))))
    (define lowMaze (append (remove (last upperMaze) upperMaze) (list (findLow maze))))
    (list->file lowMaze "maze2.txt"))
    (define leftMaze (append (list (findLeft "maze2.txt"))(remove (car (columnMaze "maze2.txt")) (columnMaze "maze2.txt"))))
    #|(define rightMaze (append (remove (last leftMaze) leftMaze) (list (findRight "maze2.txt"))))
    (list->file rightMaze "maze2.txt")
    (define toTree (list->file (columnMaze "maze2.txt") "fMaze.txt"))
    (read-maze "fMaze.txt"))|#

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

;-----------------------------------------------------------------------------*

;**** Find 0s in a list and change to 2
(define (test data)
    (if (list? data)
        (map(lambda (lst) (test lst))data)
        (if (equal? data "0")
            "2"
            data)))

;**********************************************************************************************-
;-------------------Functions to find entrance amonst the four outer walls
;**** Replace 0 to 2 in our TopWall
(define (findUpper maze)
    (test (car (read-maze maze))))

;**** Replace 0 to 2 in our bottomWall
(define (findLow maze)
    (test (last (read-maze maze))))

;**** Replace 0 to 2 in our leftWall
(define (findLeft maze)
    (test (car (columnMaze maze))))

;***** Replace 0 to 2 in our rightWall
(define (findRight maze)
    (test (last (columnMaze maze))))
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

;print resultMaze
(define (outputListData list)
  (cond 
    [(null? list) #f]
    [else (printf "~s\n" (first list))
          (outputListData (rest list))]))

;get entrance coordinates in x and y 
(define(helper-dfs maze) 
    (define entrance(findStart maze))
    (define solver(dfs (read-maze maze) (car entrance) (last entrance)))
    solver)
    
;find alternative paths for the solution
(define (dfs maze x y)
    (let loop               ;loop that updates the maze with "*" for the 0s path only
    ([resultMaze maze]
    [x x]
    [y y])
    (if (string=? (finder resultMaze x y) "2")
        (and (printf "-----------Solutions---------\n" ) (outputListData resultMaze))
        (begin          
        (cond [(or (string=? (finder resultMaze (+ x 1) y) "0") (string=? (finder resultMaze (+ x 1) y) "2")) (loop (changer resultMaze x y "*") (+ x 1) y )])
        (cond [(or (string=? (finder resultMaze (- x 1) y) "0") (string=? (finder resultMaze (- x 1) y) "2")) (loop (changer resultMaze x y "*") (- x 1) y)])
        (cond [(or (string=? (finder resultMaze x (+ y 1)) "0") (string=? (finder resultMaze x (+ y 1)) "2")) (loop (changer resultMaze x y "*") x (+ y 1))])
        (cond [(or (string=? (finder resultMaze x (- y 1)) "0") (string=? (finder resultMaze x (- y 1)) "2")) (loop (changer resultMaze x y "*") x (- y 1))])
        ))))

;returns value given x and y indexes
(define(finder maze x y)
    (define findY(list-ref maze y))
    (list-ref findY x))

;returns list with "*" chars 
(define (changer maze x y s)
    (define changeY(list-ref maze y))
    (define changeX(list-set changeY x s))
    (define resultMaze(list-set maze y changeX))
    resultMaze)

;function that runs the entire program
(define (main maze)
    (newMaze maze)
    (SealEntrance "fMaze.txt")
    (helper-dfs "fMaze.txt"))