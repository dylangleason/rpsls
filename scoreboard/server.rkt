#lang racket

(require "../lib/request.rkt"
         "../lib/response.rkt"
         "../lib/server.rkt"
         web-server/dispatch)

(define app-port 9090)

(run-server
 (lambda (req) (route req)) app-port)
