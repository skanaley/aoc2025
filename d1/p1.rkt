#lang racket/base
(require (for-syntax racket/base
                     racket/syntax
                     syntax/parse
                     racket/set)
         racket/file)

(define dial0 50)

(define-syntax (define-enum stx)
  (syntax-parse stx
    [(_ NAME:id VAL:id ...)
     #'(begin
         (define-syntax NAME (seteq 'VAL ...))
         (define-syntax VAL #''VAL)
         ...)]))

(define-syntax (enum-case stx)
  (syntax-parse stx
    [(_ NAME:id VAL:expr
        [(E:id ...+) BODY ...+]
        ...)
     (define n (syntax-local-value #'NAME))
     (define es (list->seteq (syntax->datum #'(E ... ...))))
     (define miss (set-subtract n es))
     (unless (set-empty? miss)
       (error 'enum-case "missing cases for ~a" (set->list miss)))
     (define extra (set-subtract es n))
     (unless (set-empty? extra)
       (error 'enum-case "extra cases in ~a: ~a" (syntax-e #'NAME) (set->list extra)))
     #'(case VAL
         [(E ...) BODY ...]
         ...)]))

(define-enum Dir L R)

(for/fold ([dial dial0] [0s 0] #:result 0s)
          ([l (file->lines "/home/skanaley/dev/aoc2025/i1")])
  (define num (string->number (substring l 1)))
  (define op (enum-case Dir (string->symbol (substring l 0 1))
                        [(L) -]
                        [(R) +]))
  (define next (modulo (op dial num) 100))
  (values next
          (if (zero? next)
              (add1 0s)
              0s)))