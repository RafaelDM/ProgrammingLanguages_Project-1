;Daniel Atilano
;Rafael Díaz
;4/12/2020
;Final Project

#lang racket


(define (read-maze filename)
    (define in (open-input-file filename))
        (let loop
            ([lines (read-line in 'any)]
            [maze empty])
            (if (eof-object? lines)
                maze
                (loop (read-line in 'any) (append maze (for/list () lines))))))




