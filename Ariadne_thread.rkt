;Daniel Atilano
;Rafael Medina
;4/12/2020
;Final Project

#lang racket

;---------Create the New Maze is like our main xD
;***** Change Lines of the list of list to new lines with 2
(define (newMaze maze)
    (define upperMaze(repl (car(read-maze maze)) (findUpper maze) (read-maze maze)))
    (define lowMaze(repl (last(read-maze maze)) (findLow maze) upperMaze))
    (list->file lowMaze "maze2.txt")
    (define leftMaze(repl (car(columnMaze "maze2.txt")) (findLeft "maze2.txt") (columnMaze "maze2.txt")))
    (define rightMaze(repl (last(columnMaze "maze2.txt")) (findRight "maze2.txt") leftMaze))
    (list->file rightMaze "maze2.txt")
    (define toTree (list->file (columnMaze "maze2.txt") "fMaze.txt"))
    (read-maze "fMaze.txt"))
    ;! (flatten(read-maze "fMaze.txt")) esto hace una sola lista la lista de listas

;*******************- Read Maze *****************************************
;** Read our maze line by line in Rows
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

;** Read our Maze in columns
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

;*******************- Functions to change elements **************************************
;**** Find the 0 in a list and change to 2
(define (test data)
    (if (list? data)
        (map(lambda (lst) (test lst))data)
        (if (equal? data "0")
            "2"
            data)))
;!!!!!!!
;******* Tenemos un error con esta fucnión, si tenemos filas identicas a la entrada o salida igual les pone un dos
;!!!!!!!
(define (repl oldElement newElement origMaze)
  (cond
        ((null? origMaze) origMaze)
        ((equal? oldElement origMaze) newElement)
        ((pair? origMaze) (cons (repl oldElement newElement (first origMaze))(repl oldElement newElement (rest origMaze))))
        (else origMaze)))
;**********************************************************************************************-

;-------------------Functions to get the list with the answer
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


;& Almost trash but here to use if the others functions doesn't work
#|

(define(changer maze)
    (changeLines (columnMaze maze) (findRight maze) (last (columnMaze maze))))

(define (newMaze maze)
    (cond
    ((eq? (checker(findUpper maze)) #t)(findUpper maze))
    ((eq? (checker(findRight maze)) #t)(findRight maze))
    ((eq? (checker(findLow maze)) #t)(findLow maze))
    ((eq? (checker(findLeft maze)) #t)(findLeft maze))
    ))

(define (findLeft maze)
    (let loop
        ([line empty]
        [left<-column empty]
        [maze (read-maze maze)])
        (if (empty? maze)
            (test left<-column)
            (loop (car maze) (append left<-column (list (car (car maze)))) (cdr maze))))) 

(define (findRight maze)
    (let loop
        ([line empty]
        [right<-column empty]
        [maze (read-maze maze)])
        (if (empty? maze)
            (test right<-column)
            (loop (last maze) (append right<-column (list (last (car maze)))) (cdr maze))))) 
|#