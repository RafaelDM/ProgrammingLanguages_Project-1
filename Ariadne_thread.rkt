;Daniel Atilano
;Rafael Medina
;4/12/2020
;Final Project

#lang racket

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
    (let loop
        ([line empty]
        [left<-column empty]
        [maze (read-maze maze)])
        (if (empty? maze)
            (test left<-column)
            (loop (car maze) (append left<-column (list (car (car maze)))) (cdr maze))))) 

;***** Replace 0 to 2 in our rightWall
(define (findRight maze)
    (let loop
        ([line empty]
        [right<-column empty]
        [maze (read-maze maze)])
        (if (empty? maze)
            (test right<-column)
            (loop (last maze) (append right<-column (list (last (car maze)))) (cdr maze))))) 