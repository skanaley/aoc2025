#lang racket/base
(require racket/file
         racket/list
         racket/string)

#;(define test "987654321111111
811111111111119
234234234234278
818181911112111")

(define (row-max s)
  (define out-size 12)
  (define (digit c) (- (char->integer c) 48))
  (define v (for/vector ([c s]) (digit c)))
  (define (v@ i) (vector-ref v i))
  (define len (vector-length v))
  (define false# (- len out-size))

  (define b (make-vector len #t));are we keeping these digits?
  (define (@ i) (vector-ref b i))
  (define (! i x) (vector-set! b i x))
  (define (!l i j) (! i #t) (! j #f));"left"
  (for ([i false#]) (! i #f));start with the right-most digits, try to left-ify them

  (define (imax lo hi)
    (for/fold ([md 0] [mi 0])
              ([i (in-range lo hi)])
      (define d (v@ i))
      (if (> d md);return left-most, i.e. not >=
          (values d i)
          (values md mi))))

  (let loop ([i 0] [j false#])
    #|(displayln (cons i j))
    (displayln v)
    (displayln (for/vector ([? b]
                            [d v])
                 (if ? d '-)))
    (newline)|#
    (when (< j len)
      (define d (v@ j))
      (define-values (md mi) (imax i j))
      (when (>= md d);push as far left as possible
        (!l mi j)
        (loop (add1 mi) (add1 j)))))

  (for/fold ([n 0])
            ([? b]
             [d v]
             #:when ?)
    (+ d (* n 10))))

(for/fold ([n 0])
          ([l #;(string-split test "\n")
              (file->lines "/home/skanaley/dev/aoc2025/d3/input.txt")])
  (+ n (row-max l)))