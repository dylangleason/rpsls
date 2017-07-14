#lang racket

(require web-server/servlet
         web-server/servlet-env)

(provide run-server)

(define (run-server f port)
  (begin
    (printf "Listening on port ~s\n" port)
    (serve/servlet f
                   #:command-line? #t
                   #:launch-browser? #f
                   #:port port
                   #:servlet-path "/"
                   #:servlet-regexp #rx"")))
