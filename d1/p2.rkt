#lang racket/base
(require racket/file)

(for/fold ([dial 50] [0s 0] #:result 0s)
          ([l (file->lines "/home/skanaley/dev/aoc2025/i1")])
  (define op (case (string-ref l 0)
               [(#\L) sub1]
               [(#\R) add1]))
  (for/fold ([dial dial] [0s 0s])
            ([i (string->number (substring l 1))])
    (define dial* (modulo (op dial) 100))
    (values dial*
            (if (zero? dial*)
                (add1 0s)
                0s))))