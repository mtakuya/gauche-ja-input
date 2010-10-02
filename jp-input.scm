#!/usr/bin/env gosh

(use rfc.uri)
(use rfc.http)
(use text.tr)
(use srfi-13)
(use gauche.charconv)

(define *google* "www.google.com")
(define *query* "/transliterate?langpair=ja-Hira|ja&text=")

(define (result str)
  (let1 cstr
      (ces-convert
       (values-ref
        (http-get *google* (string-append *query* str) :accept-language "ja") 2)
       "*jp" "utf-8")
    (set! cstr (string-tr cstr "[" "("))
    (set! cstr (string-tr cstr "]" ")"))
    (set! cstr (string-delete cstr #\,))    
    (set! cstr (string-delete cstr #\newline))
    cstr))
    
(define (string->ja-input str)
  (let1 cstr (result str)
    (car (port->sexp-list (open-input-string cstr)))))

(print (string->ja-input "ここではきものをぬぐ"))