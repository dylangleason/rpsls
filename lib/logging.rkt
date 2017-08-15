#lang racket

(require racket/date
         web-server/http/request-structs)

(provide log/debug
         log/error
         log/info
         log/warn
         receive-log)

(date-display-format 'iso-8601)

(define-logger logger)

(define (receive-log level)
  (let ([recv (make-log-receiver (current-logger) level)])
    (thread
     (lambda ()
       (let loop ()
         (define v (sync recv))
         (printf "~a ~a\n"
                 (~.a
                  (string-upcase (symbol->string (vector-ref v 0)))
                  #:width 7)
                 (vector-ref v 1))
         (loop))))))

(define (log/debug message)
  (log-debug (log-format message)))

(define (log/info message)
  (log-info (log-format message)))

(define (log/error message)
  (log-error (log-format message)))

(define (log/warn message)
  (log-warning (log-format message)))

(define (log-format message)
  (format "~a ~a"
          (date->string (current-date) #t)
          message))
