;Daniel Atilano
;Rafael Medina
;4/12/2020
;Final Project

#lang racket

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

;----Debemos de hacer una función pa cada uno y luego la función
;--Que busca el true y false y es con lo que 
;**** Find the 0 in a list and change to 2
(define (test data)
    (if (list? data)
        (map(lambda (lst) (test lst))data)
        (if (equal? data "0")
            "2"
            data)))
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

            
;***** Function to check what is the column with 2
(define (checker data)
    (if(list? (member "2" data))
    #t
    #f
    ))

;--Debemos de hacer una función que evalue los cuatro casos para saber cual cambio
;--Despues de saber cual cambio vamos a tomar la nueva lista con 2 y la vamos a pegar donde estaban los 0

;* Creo que tal vez debemos de hacer un loop que cuente hasta 4 y que vaya evaluando en cada iteración un lado diferente
;* En caso de que le toque un t entonces agarra de donde viene el true y cambia la nueva lista por la vieja
;* para eso estaba pensando en usar una función parecida a nuestro test pero que ahora funcione con las listas
;* en el caso de Nuestra pared superior e inferior funcionaría esa
;* en el caso de nuestra pared izquierda y derecha no funcionaria, tendriamos que iterar de otra manera
;* O lo que podríamos hacer es tener dos Reader de Maze, pero ahora ir envertidos! para construirla al revez

;! Esta Funcion da problemas porque solo imprime el primer caso y ya, necesitamos que evalue todas e imprima 2






;& Almost trash but here to use if the others functions doesn't work
#|
(define (newMaze maze)
    (cond
    ((eq? (checker(findUpper maze)) #t)(findUpper maze))
    ((eq? (checker(findRight maze)) #t)(findRight maze))
    ((eq? (checker(findLow maze)) #t)(findLow maze))
    ((eq? (checker(findLeft maze)) #t)(findLeft maze))
    ))
    |#
#|
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