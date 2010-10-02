;;;
;;; ja-input.scm - Google CGI API for Japanese Input Module.
;;;
;;; Copyright (c) 2010 Takuya Mannami <mtakuya@users.sourceforge.jp>
;;;
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:
;;;
;;; 1. Redistributions of source code must retain the above copyright
;;; notice, this list of conditions and the following disclaimer.
;;;
;;; 2. Redistributions in binary form must reproduce the above copyright
;;; notice, this list of conditions and the following disclaimer in the
;;; documentation and/or other materials provided with the distribution.
;;;
;;; 3. Neither the name of the authors nor the names of its contributors
;;; may be used to endorse or promote products derived from this
;;; software without specific prior written permission.
;;;
;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;;; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;;; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
;;; A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
;;; OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
;;; SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
;;; TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
;;; PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
;;; LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;;;
(define-module ja-input
  (use rfc.uri)
  (use rfc.http)
  (use text.tr)
  (use srfi-13)
  (use gauche.charconv) 
  (export string->ja-input-list))
(select-module ja-input)

(define *google* "www.google.com")
(define *query* "/transliterate?langpair=ja-Hira|ja&text=")

(define (result str)
  (let1 cstr
      (ces-convert
       (values-ref
        (http-get *google* (string-append *query* str)) 2)
       "*jp" "utf-8")
    (set! cstr (string-tr cstr "[" "("))
    (set! cstr (string-tr cstr "]" ")"))
    (set! cstr (string-delete cstr #\,))    
    (set! cstr (string-delete cstr #\newline))
    cstr))
    
(define (string->ja-input-list str)
  (let1 cstr (result str)
    (car (port->sexp-list (open-input-string cstr)))))
(provide "ja-input")