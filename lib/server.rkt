#lang racket

(require "./logging.rkt"
         net/url-string
         web-server/servlet
         web-server/servlet-env
         web-server/dispatchers/dispatch-log)

(provide dispatch-request
         middleware/log-request
         middleware/log-response
         run)

(define (middleware/log-request req)
  (begin0
    req
    (log/info
     (format "~a ~a ~a"
             (current-seconds)
             (bytes->string/utf-8 (request-method req))
             (url->string (request-uri req))))))

(define (middleware/log-response res)
  (begin0
    res
    (log/info
     (format "~a ~a [~a]"
             (response-seconds res)
             (bytes->string/utf-8 (response-message res))
             (response-code res)))))

(define dispatch-request
  (lambda (req route-fn #:pre [pre empty] #:post [post empty])
    (letrec ([loop
              (lambda (req fns)
                (if (empty? fns)
                    req
                    (loop ((car fns) req) (cdr fns))))])
      (loop (route-fn (loop req pre)) post))))

(define (run port dispatch-fn)
  (begin
    (receive-log 'info)
    (log/info (format "Server listening on port ~a" port))
    (serve/servlet
     dispatch-fn
     #:command-line? #t
     #:launch-browser? #f
     #:port port
     #:servlet-path "/"
     #:servlet-regexp #rx""
     #:stateless? #t)))
