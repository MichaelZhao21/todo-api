#lang racket/base

(require (prefix-in dispatch: web-server/dispatch)
         (prefix-in json: web-server/http/json)
         (prefix-in servlet: web-server/servlet-env))

(printf "Curr path: ~a~n" (find-system-path 'orig-dir))

;; 404 page
(define (not-found-route request)
  (json:response/jsexpr
   #hasheq((message . "Invalid route!") (status . 404))
   #:code 404))

;; [GET /] Returns full list of todo items
(define (get-all request)
  (json:response/jsexpr
   #hasheq((message . "hello world!") (status . 200))))

;; Router
(define-values (route-dispatch route-url)
  (dispatch:dispatch-rules
   [("") #:method "get" get-all]
   [else not-found-route]))

;; Server
(servlet:serve/servlet
 route-dispatch
 #:servlet-path "/"
 #:servlet-regexp #rx""
 #:stateless? #t)
