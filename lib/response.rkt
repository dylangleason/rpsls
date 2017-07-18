#lang racket

(require json
         web-server/http/response-structs)

(provide response/ok
         response/created
         response/not-found
         response/unprocessable-entity
         response/json)

(define response/json
  (lambda (code #:body [body empty] #:headers [headers empty])
    (response
     code
     (status-code->message code)
     (current-seconds)
     #"application/json; charset=utf-8"
     headers
     (lambda (op)
       (write-json (force body) op)))))

(define response/ok
  (lambda (body #:headers [headers empty])
    (response/json 200 #:body body #:headers headers)))

(define response/created
  (lambda (body #:headers [headers empty])
    (response/json 201 #:body body #:headers headers)))

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
    [(404) #"Not Found"]
    [(422) #"Unprocessable Entity"]
    [(500) #"Internal Server Error"]
    [else  #"Unknown Status"]))
