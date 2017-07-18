#lang racket

(require racket/date
         net/url-string
         web-server/http/request-structs)

(provide app-log/crit
         app-log/debug
         app-log/error
         app-log/info
         app-log/warn
         access-log/crit
         access-log/debug
         access-log/error
         access-log/info
         access-log/warn)

(date-display-format 'rfc2822)

(define (app-log/crit message)
  (app-log message "CRITICAL"))

(define (app-log/debug message)
  (app-log message "DEBUG"))

(define (app-log/error message)
  (app-log message "ERROR"))

(define (app-log/info message)
  (app-log message "INFO"))

(define (app-log/warn message)
  (app-log message "WARNING"))

(define (access-log/crit req)
  (access-log req "CRITICAL"))

(define (access-log/debug req)
  (access-log req "DEBUG"))

(define (access-log/error req)
  (access-log req "ERROR"))

(define (access-log/info req)
  (access-log req "INFO"))

(define (access-log/warn req)
  (access-log req "WARNING"))

(define (app-log message level)
  (write-log
   (format "~a ~a\n" (log-format level) message)))

(define (access-log req level)
  (write-log
   (format "~a ~a ~a\n"
           (log-format level)
           (bytes->string/utf-8 (request-method req))
           (url->string (request-uri req)))))

(define (log-format level)
  (format "[~a] - ~a:"
          (date->string (current-date) #t)
          level))

(define (write-log input)
  (display input)
  (flush-output))
