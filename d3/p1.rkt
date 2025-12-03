#lang racket/base
(require racket/file
         racket/list
         racket/string)

#;(define test "987654321111111
811111111111119
234234234234278
818181911112111")

(define (row-max s)
  (define (digit c)
    (- (char->integer c) 48))

  (define (imax ds)
    (for/fold ([md 1] [mi 0])
              ([(d i) (in-indexed ds)])
      (if (> d md)
          (values d i)
          (values md mi))))

  (define (digit-pair->number a b)
    (+ b (* a 10)))

  (define ds (map digit (string->list s)))
  (define len (length ds))

  (define-values (md mi) (imax ds))

  (define-values (left right)
    (cond [(= mi (sub1 len))
           (define-values (od oi) (imax (take ds (sub1 len))));"other"
           (values od md)]
          [else
           (define-values (od oi) (imax (drop ds (add1 mi))))
           (values md od)]))
  
  (digit-pair->number left right))

(for/fold ([n 0])
          ([l #;(string-split test "\n")
              (file->lines "/home/skanaley/dev/aoc2025/d3/input.txt")])
  (+ n (row-max l)))