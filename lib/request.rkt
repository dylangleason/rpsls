#lang racket

(require json
         web-server/http/request-structs)

(provide post-data->jsexpr
         query-param->int
         query-param->string)

(define (query-param->string req key)
  (let ([val (bindings-assq (string->bytes/utf-8 key)
                            (request-bindings/raw req))])
    (if (not val)
        (raise (error (format "~a param is missing" key)))
        (bytes->string/utf-8 (binding:form-value val)))))

(define (query-param->int req key)
  (let ([number (string->number (query-param->string req key))])
    (if (not (and number (integer? number)))
        (raise (error (format "~a param is not an integer" key)))
        number)))

(define (post-data->jsexpr req)
  (bytes->jsexpr (request-post-data/raw req)))
