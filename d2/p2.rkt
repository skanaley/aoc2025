#lang racket/base
(require racket/file
         racket/match
         racket/string)

;(define test "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124")

(for/fold ([n 0])
          ([s (string-split (file->string "/home/skanaley/dev/aoc2025/i2") ",")])
  (match-define (list lo hi) (map string->number (string-split s "-")))
  (for/fold ([n n])
            ([i (in-range lo (add1 hi) 1)]
             #:do [(define i* (number->string i))
                   (define len (string-length i*))])
    (if (for/or ([tl (in-range 1 (add1 (quotient len 2)))]
                 #:do [(define t (substring i* 0 tl))])
          (for/and ([j (in-range tl len tl)])
            (string=? t (substring i* j (min len (+ j tl))))))
        (+ n i)
        n)))