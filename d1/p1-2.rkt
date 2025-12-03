#lang racket/base
(require racket/file)

(for/fold ([dial 50] [0s 0] #:result 0s)
          ([l (file->lines "/home/skanaley/dev/aoc2025/i1")])
  (define num (string->number (substring l 1)))
  (define op (case (string-ref l 0)
               [(#\L) -]
               [(#\R) +]))
  (define next (modulo (op dial num) 100))
  (values next
          (if (zero? next)
              (add1 0s)
              0s)))