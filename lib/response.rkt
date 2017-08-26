#lang racket

(require json
         web-server/http/response-structs)

(define content-type-json #"application/json; charset=utf-8")
(define content-type-text #"text/plain")

(define (response-writer-fn content-type)
  (if (bytes=? content-type content-type-json)
      write-json
      write))

(define response/content-type
  (lambda (code content-type #:body [body empty] #:headers [headers empty])
    (response
     code
     (status-code->message code)
     (current-seconds)
     content-type
     headers
     (lambda (out)
       (when (not (= code 204))
         ((response-writer-fn content-type) (force body) out))))))

(define response/text
  (lambda (code #:body [body empty] #:headers [headers empty])
    (response/content-type
     code
     content-type-text
     #:body body
     #:headers headers)))

(define response/json
  (lambda (code #:body [body empty] #:headers [headers empty])
    (response/content-type
     code
     content-type-json
     #:body body
     #:headers headers)))

(define response/ok
  (lambda (body #:headers [headers empty])
    (response/json 200 #:body body #:headers headers)))

(define response/created
  (lambda (body #:headers [headers empty])
    (response/json 201 #:body body #:headers headers)))

(define response/no-content
  (lambda (#:headers [headers empty])
    (response/text 204 #:headers headers)))

(define response/not-found
  (lambda (#:headers [headers empty])
    (response/json 404 #:body #hash() #:headers headers)))

(define response/unprocessable-entity
  (lambda (body #:headers [headers empty])
    (response/json 422 #:body body #:headers headers)))

(define (status-code->message code)
  (case code
    [(200) #"OK"]
    [(201) #"Created"]
    [(204) #"No Content"]
    [(404) #"Not Found"]
    [(422) #"Unprocessable Entity"]
    [(500) #"Internal Server Error"]
    [else  #"Unknown Status"]))

(provide response/ok
         response/created
         response/no-content
         response/not-found
         response/unprocessable-entity
         response/json)
