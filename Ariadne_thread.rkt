;Daniel Atilano
;Rafael Medina
;4/12/2020
;Final Project

#lang racket


;***** Change Lines of the list of list to new lines with 2
(define (newMaze maze)
    (define upperMaze (append (list (findUpper maze))(remove (car (read-maze maze)) (read-maze maze))))
    (define lowMaze (append (remove (last upperMaze) upperMaze) (list (findLow maze))))
    (list->file lowMaze "maze2.txt")
    (define leftMaze (append (list (findLeft "maze2.txt"))(remove (car (columnMaze "maze2.txt")) (columnMaze "maze2.txt"))))
    (define rightMaze (append (remove (last leftMaze) leftMaze) (list (findRight "maze2.txt"))))
    (list->file rightMaze "maze2.txt")
    (define toTree (list->file (columnMaze "maze2.txt") "fMaze.txt"))
    (read-maze "fMaze.txt"))

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
                    
;return lists without walls
(define (noWalls row i_counter)
    (for/list ([j row] [j_counter (in-naturals 1)] #:unless (string=? j "1") )  (append (list i_counter) (list j_counter) (list j) )))


;build nodes with x y coordinates and ID 
(define (path->nodes maze)
    (let loop
        ([rows (read-maze maze)]
        [pathsList empty]
        [i 1])
        (if (empty? rows)  
            (findRoot (map (λ (x y) (append (list x) y)) (range (length pathsList)) pathsList) (sub1 i));once each node is assigned x y coordinates, add an ID.
            (loop (cdr rows) (append pathsList (noWalls (car rows) i)) (add1 i)))))
            
;function to find coordenates of an entrance 
(define (findRoot paths size)
    (define nodes paths)
    (let loop
        ([entrance paths]
        [limits size])
        (if (empty? entrance)
            (display "Invalid maze")
            (if (or (eq? (cadar entrance) limits)  (eq? (cadar entrance) 1)); (eq? (caddar entrance) limits) (eq? (caddar entrance) 1))
                (maze->tree (car entrance) nodes)
                (if (or (eq? (caddar entrance) limits)  (eq? (caddar entrance) 1))
                    (maze->tree (car entrance) nodes)
                    (loop (cdr entrance) limits))))))
                    
(define (sort-leafs entrance nodes)
    (define leafs (remove entrance nodes))
    leafs)
    #|
    (let loop
        ([sortedLeafs (list entrance)]
        [leafs leafs]
        [root entrance])
        (if (empty? leafs)
            sortedLeafs
            (if (and (or (eq? (cadr root) (cadar leafs)) (eq? (add1 (cadr root)) (cadar leafs)) (eq? (sub1 (cadr root)) (cadar leafs)))
                (or (eq? (caddr root) (caddar leafs)) (eq? (add1 (caddr root)) (caddar leafs)) (eq? (sub1 (caddr root)) (caddar leafs))))
                (loop (append sortedLeafs (list (car leafs))) (cdr leafs) (car leafs))
                (loop sortedLeafs (cdr leafs) (car leafs))))))
    |#
                    
;build tree                    
(define (maze->tree entrance nodes)
    ;remove entrance from the remaining nodes
    (define leafs (remove entrance nodes))
    (let loop
        ([root entrance]
        [leafs leafs]
        [tree empty]
        ;booleans to know if neighbor has been visited
        [left #f]
        [right #f]
        [up #f]
        [down #f])
        (if (empty? leafs)
            tree
            ;add neighbors as children
            (cond 
                [(and (eq? right #t) (not (empty? root))) (loop (car leafs) (cdr leafs) (append tree (list (append (list root) (list (caar leafs))))) left right up down)] ;caar to get ID
                [(and (eq? left #t) (not (empty? root))) (loop (car leafs) (cdr leafs) (append tree (list (append (list root) (list (caar leafs))))) left right up down)]
                [(and (eq? up #t) (not (empty? root))) (loop (car leafs) (cdr leafs) (append tree (list (append (list root) (list (caar leafs))))) left right up down)]
                [(and (eq? down #t) (not (empty? root))) (loop (car leafs) (cdr leafs) (append tree (list (append (list root) (list (caar leafs))))) left right up down)]
                [else
                    (cond
                    [(eq? (add1 (cadr root)) (cadar leafs)) (loop root leafs tree #f #t #f #f)] 
                    [(eq? (sub1 (cadr root)) (cadar leafs)) (loop root leafs tree #t #f #f #f)]
                    [(eq? (add1 (caddr root)) (caddar leafs)) (loop root leafs tree #f #f #f #t)]
                    [(eq? (sub1 (caddr root)) (caddar leafs)) (loop root leafs tree #f #f #t #f)]
                    [else   
                        (loop '() tree left right up down)]) ]))))
    

(define (see-nodes maze)
    (define paths (path->nodes maze))
     paths)  ;cdddr to read last value of a node
     

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

(define (findDoor maze)
    (define door (list))
    (cond 
    [(index-of (last (read-maze maze)) "2")(append door (list (index-of (last (read-maze maze)) "2")(- (length (read-maze maze)) 1)))]
    [(index-of (car (read-maze maze)) "2")(append door (list  (index-of (car (read-maze maze)) "2") 0))]
    [(index-of (last (columnMaze maze)) "2")(append door (list (- (length (columnMaze maze)) 1) (index-of (last (columnMaze maze)) "2")))]
    [(index-of (car (columnMaze maze)) "2")(append door (list 0 (index-of (car (columnMaze maze)) "2")))]))

#|
(define dfs (lambda ((read-maze maze) x y)
    (if (eq? (list-ref maze x y) "2")
        (print maze)
        (begin0
          (cond [(or (eq? (list-ref maze (+ x 1) y) "0")
                     (string=? (list-ref maze (+ x 1) y) "2"))
                 (dfs (set maze x y "*") (+ x 1) y)])
          (cond [(or (eq? (list-ref maze (- x 1) y) "0")
                     (eq? (list-ref maze (- x 1) y) "2"))
                 (dfs (set maze x y "*") (- x 1) y)])
          (cond [(or (eq? (list-ref maze x (+ y 1)) "0")
                     (eq? (list-ref maze x (+ y 1)) "2"))
                 (dfs (set maze x y "*") x (+ y 1))])
          (cond [(or (eq? (list-ref maze x (- y 1)) "0")
                     (eq? (list-ref maze x (- y 1)) "2"))
                 (dfs (set maze x y "*") x (- y 1))])))))
|#

;- (index-of '(1 2 3 4) 3)
;- (length (list "hop" "skip" "jump"))  

;-- La función respuesta debe de encontrar al ultimo nodo que tenga la salida y recibe lo de abajo, debe de remontar la respuesta desde el 2 salida por el papá
;-- La función de arriba encuentra el camnino e imprime la salida 

;-------(x y)
;-------(1 4) read-maze Last
;-------(0 2) columnMaze Car
;-------(3 0) read-maze Car
;-------(4 1) columnMaze Last

;-- Respuesta Maze ((0, 0, 2, (2, 5)), (1, 0 , 0, (2,4)), (2, 1, 0, (3,4)), (3, 2, 0, (3,3)), (7, 3, 0, (3,2)), (4, 3, 0, (4,3)), (5, 4, 2, (5,3)))


;& Almost trash but here to use if the others functions doesn't work
#|
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

;---Usar el lenght y solo cambiar la ultima o la primera que esta en el length

#|
(define (repl oldElement newElement origMaze)
  (cond
        ((null? origMaze) origMaze)
        ((equal? oldElement origMaze) newElement)
        ((pair? origMaze) (cons (repl oldElement newElement (first origMaze))(repl oldElement newElement (rest origMaze))))
        (else origMaze)))
        |#
       
#|
 if i j = 0{
        if i j-1 =0 {
            if (nodoId!= NULL){
                ya tiene familia ahí dejalo
            }
            else{
                Escribo que este es tu hijo y lo bautizas
            }
        }
        if i j+1=0{
            if (nodoId!= NULL){
                ya tiene familia ahí dejalo
            }
            else{
                Escribo que este es tu hijo y lo bautizas
            }
        }
        if i+1 j=0{
            if (nodoId!= NULL){
                ya tiene familia ahí dejalo
            }
            else{
                Escribo que este es tu hijo y lo bautizas
            }
        }
        if i-1 j=0{
            if (nodoId!= NULL){
                ya tiene familia ahí dejalo
            }
            else{
                Escribo que este es tu hijo y lo bautizas
            }
        }
    }
|#
