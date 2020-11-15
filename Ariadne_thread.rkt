;Daniel Atilano
;Rafael Díaz
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

(define (findUpper maze)
    (define upperRow (car (read-maze maze)))
    (if (list? (member "0" upperRow))
    #t
    #f
    ));* Read Upper Column

(define (findLow maze)
    (define lowRow (last (read-maze maze)))
    (list? lowRow))
;(map (λ (square) (if (eq? square "0") "2" square)) lowRow))

(define (test)
    (define data '("1" "0"))
    (map (λ (square) (if (eq? square "0") "2" square)) data)
    (list? data))

(define (findLeft maze)
    (let loop
        ([line empty]
        [left<-column empty]
        [maze (read-maze maze)])
        (if (empty? maze)
            left<-column
            (loop (car maze) (append left<-column (list (car (car maze)))) (cdr maze))))) ;* reads Left column

(define (findRight maze)
    (let loop
        ([line empty]
        [right<-column empty]
        [maze (read-maze maze)])
        (if (empty? maze)
            right<-column
            (loop (last maze) (append right<-column (list (last (car maze)))) (cdr maze))))) ;* Read Right Column



