(uiop/package:define-package chroma (:use)
                             (:import-from #:cl #:append #:declaim #:declare
                              #:ignorable #:optimize #:speed #:space #:safety
                              #:debug #:compilation-speed #:defparameter #:null
                              #:case #:array #:write-to-string #:setf
                              #:defparameter #:defun #:fdefinition #:t #:nil
                              #:&key #:when #:let* #:or #:if #:cdr #:assoc
                              #:quote #:string-equal #:cons #:list #:cond
                              #:find #:warn #:boundp #:symbol-value #:string
                              #:integer #:number #:boolean #:let #:unless
                              #:make-string-output-stream
                              #:get-output-stream-string #:string= #:hash-table
                              #:stream #:typep #:progn #:ignore-errors
                              #:stringp #:not #:otherwise)
                             (:import-from #:quri #:uri #:make-uri #:render-uri
                              #:uri-scheme #:uri-host #:uri-port)
                             (:import-from #:str #:concat)
                             (:import-from #:com.inuoe.jzon #:parse
                              #:with-writer* #:write-key* #:write-value*
                              #:stringify)
                             (:import-from #:openapi-generator
                              #:remove-empty-values #:json-null #:json-number
                              #:json-array #:json-object #:json-false
                              #:json-true)
                             (:import-from #:dexador #:request)
                             (:import-from #:serapeum #:assuref)
                             (:export #:*authorization* #:*headers* #:*cookie*
                              #:*parse* #:*server* "UPDATE-COLLECTION"
                              "GET-COLLECTION" "DELETE-COLLECTION"
                              "GET-NEAREST-NEIGHBORS" "COUNT" "DELETE" "GET"
                              "UPSERT" "UPDATE" "ADD" "LIST-COLLECTIONS"
                              "CREATE-COLLECTION" "PRE-FLIGHT-CHECKS"
                              "HEARTBEAT" "VERSION" "RESET" "ROOT"))

(in-package :chroma)

(defparameter *parse* t)
(defparameter *authorization* nil)
(defparameter *server* "http://localhost:8000")
(defparameter *cookie* nil)
(defparameter *headers* 'nil)
(defparameter *query* 'nil)


(defun put/api/v1/collections/{collection_id}
       (collection-id
        &key (query *query*) (headers *headers*) (cookie *cookie*)
        (authorization *authorization*) (server *server*) (parse *parse*)
        update-collection new-name new-metadata content)
  "Operation-id: update-collection
Summary: Update Collection"
  (serapeum:assuref collection-id string)
  (let* ((server-uri (quri.uri:uri (or server "")))
         (response
          (dexador.backend.usocket:request
           (quri:render-uri
            (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                           (quri.uri:uri-host server-uri) :port
                           (quri.uri:uri-port server-uri) :path
                           (str:concat (quri.uri:uri-path server-uri)
                                       (str:concat "/api/v1/collections/"
                                                   collection-id))
                           :query
                           (openapi-generator::remove-empty-values
                            (when query query))))
           :content
           (cond
            (content
             (if (not
                  (stringp
                   (serapeum:assuref content
                                     (or openapi-generator::json-object
                                         hash-table))))
                 (com.inuoe.jzon:stringify content)
                 content))
            (update-collection
             (if (not
                  (stringp
                   (serapeum:assuref update-collection
                                     (or openapi-generator::json-object
                                         hash-table))))
                 (com.inuoe.jzon:stringify update-collection)
                 update-collection))
            ((or new-name new-metadata)
             (let ((openapi-generator::s (make-string-output-stream)))
               (declare (stream openapi-generator::s))
               (com.inuoe.jzon:with-writer* (:stream openapi-generator::s
                                             :pretty t)
                 (com.inuoe.jzon:with-object*
                   (when new-name
                     (com.inuoe.jzon:write-key* "new_name")
                     (com.inuoe.jzon:write-value*
                      (serapeum:assuref new-name string)))
                   (when new-metadata
                     (com.inuoe.jzon:write-key* "new_metadata")
                     (com.inuoe.jzon:write-value*
                      (serapeum:assuref new-metadata
                                        (or openapi-generator::json-object
                                            hash-table))))))
               (let ((openapi-generator::output
                      (get-output-stream-string openapi-generator::s)))
                 (declare (string openapi-generator::output))
                 (unless (string= "{}" openapi-generator::output)
                   openapi-generator::output)))))
           :method 'put :headers
           (openapi-generator::remove-empty-values
            (append
             (list (cons "Content-Type" "application/json")
                   (cons "Authorization" authorization) (cons "cookie" cookie))
             (when headers headers))))))
    (if parse
        (com.inuoe.jzon:parse response)
        response)))
 (defun delete/api/v1/collections/{collection_name}
        (collection-name
         &key (query *query*) (headers *headers*) (cookie *cookie*)
         (authorization *authorization*) (server *server*) (parse *parse*))
   "Operation-id: delete-collection
Summary: Delete Collection"
   (serapeum:assuref collection-name string)
   (let* ((server-uri (quri.uri:uri (or server "")))
          (response
           (dexador.backend.usocket:request
            (quri:render-uri
             (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                            (quri.uri:uri-host server-uri) :port
                            (quri.uri:uri-port server-uri) :path
                            (str:concat (quri.uri:uri-path server-uri)
                                        (str:concat "/api/v1/collections/"
                                                    collection-name))
                            :query
                            (openapi-generator::remove-empty-values
                             (when query query))))
            :method 'delete :headers
            (openapi-generator::remove-empty-values
             (append
              (list (cons "Authorization" authorization)
                    (cons "cookie" cookie))
              (when headers headers))))))
     (if parse
         (com.inuoe.jzon:parse response)
         response)))
 (defun get/api/v1/collections/{collection_name}
        (collection-name
         &key (query *query*) (headers *headers*) (cookie *cookie*)
         (authorization *authorization*) (server *server*) (parse *parse*))
   "Operation-id: get-collection
Summary: Get Collection"
   (serapeum:assuref collection-name string)
   (let* ((server-uri (quri.uri:uri (or server "")))
          (response
           (dexador.backend.usocket:request
            (quri:render-uri
             (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                            (quri.uri:uri-host server-uri) :port
                            (quri.uri:uri-port server-uri) :path
                            (str:concat (quri.uri:uri-path server-uri)
                                        (str:concat "/api/v1/collections/"
                                                    collection-name))
                            :query
                            (openapi-generator::remove-empty-values
                             (when query query))))
            :method 'get :headers
            (openapi-generator::remove-empty-values
             (append
              (list (cons "Authorization" authorization)
                    (cons "cookie" cookie))
              (when headers headers))))))
     (if parse
         (com.inuoe.jzon:parse response)
         response)))
 (defun post/api/v1/collections/{collection_id}/query
        (collection-id
         &key (query *query*) (headers *headers*) (cookie *cookie*)
         (authorization *authorization*) (server *server*) (parse *parse*)
         query-embedding where where-document query-embeddings n-results
         include content)
   "Operation-id: get-nearest-neighbors
Summary: Get Nearest Neighbors"
   (serapeum:assuref collection-id string)
   (let* ((server-uri (quri.uri:uri (or server "")))
          (response
           (dexador.backend.usocket:request
            (quri:render-uri
             (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                            (quri.uri:uri-host server-uri) :port
                            (quri.uri:uri-port server-uri) :path
                            (str:concat (quri.uri:uri-path server-uri)
                                        (str:concat "/api/v1/collections/"
                                                    collection-id "/query"))
                            :query
                            (openapi-generator::remove-empty-values
                             (when query query))))
            :content
            (cond
             (content
              (if (not
                   (stringp
                    (serapeum:assuref content
                                      (or openapi-generator::json-object
                                          hash-table))))
                  (com.inuoe.jzon:stringify content)
                  content))
             (query-embedding
              (if (not
                   (stringp
                    (serapeum:assuref query-embedding
                                      (or openapi-generator::json-object
                                          hash-table))))
                  (com.inuoe.jzon:stringify query-embedding)
                  query-embedding))
             ((or where where-document query-embeddings n-results include)
              (let ((openapi-generator::s (make-string-output-stream)))
                (declare (stream openapi-generator::s))
                (com.inuoe.jzon:with-writer* (:stream openapi-generator::s
                                              :pretty t)
                  (com.inuoe.jzon:with-object*
                    (when where
                      (com.inuoe.jzon:write-key* "where")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref where
                                         (or openapi-generator::json-object
                                             hash-table))))
                    (when where-document
                      (com.inuoe.jzon:write-key* "where_document")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref where-document
                                         (or openapi-generator::json-object
                                             hash-table))))
                    (com.inuoe.jzon:write-key* "query_embeddings")
                    (com.inuoe.jzon:write-value*
                     (progn
                      (serapeum:assuref query-embeddings
                                        (or openapi-generator::json-array
                                            list))
                      (or
                       (ignore-errors (com.inuoe.jzon:parse query-embeddings))
                       query-embeddings)))
                    (when n-results
                      (com.inuoe.jzon:write-key* "n_results")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref n-results t)))
                    (when include
                      (com.inuoe.jzon:write-key* "include")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref include
                                         (or openapi-generator::json-array
                                             list))))))
                (let ((openapi-generator::output
                       (get-output-stream-string openapi-generator::s)))
                  (declare (string openapi-generator::output))
                  (unless (string= "{}" openapi-generator::output)
                    openapi-generator::output)))))
            :method 'post :headers
            (openapi-generator::remove-empty-values
             (append
              (list (cons "Content-Type" "application/json")
                    (cons "Authorization" authorization)
                    (cons "cookie" cookie))
              (when headers headers))))))
     (if parse
         (com.inuoe.jzon:parse response)
         response)))
 (defun get/api/v1/collections/{collection_id}/count
        (collection-id
         &key (query *query*) (headers *headers*) (cookie *cookie*)
         (authorization *authorization*) (server *server*) (parse *parse*))
   "Operation-id: count
Summary: Count"
   (serapeum:assuref collection-id string)
   (let* ((server-uri (quri.uri:uri (or server "")))
          (response
           (dexador.backend.usocket:request
            (quri:render-uri
             (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                            (quri.uri:uri-host server-uri) :port
                            (quri.uri:uri-port server-uri) :path
                            (str:concat (quri.uri:uri-path server-uri)
                                        (str:concat "/api/v1/collections/"
                                                    collection-id "/count"))
                            :query
                            (openapi-generator::remove-empty-values
                             (when query query))))
            :method 'get :headers
            (openapi-generator::remove-empty-values
             (append
              (list (cons "Authorization" authorization)
                    (cons "cookie" cookie))
              (when headers headers))))))
     (if parse
         (com.inuoe.jzon:parse response)
         response)))
 (defun post/api/v1/collections/{collection_id}/delete
        (collection-id
         &key (query *query*) (headers *headers*) (cookie *cookie*)
         (authorization *authorization*) (server *server*) (parse *parse*)
         delete-embedding ids where where-document content)
   "Operation-id: delete
Summary: Delete"
   (serapeum:assuref collection-id string)
   (let* ((server-uri (quri.uri:uri (or server "")))
          (response
           (dexador.backend.usocket:request
            (quri:render-uri
             (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                            (quri.uri:uri-host server-uri) :port
                            (quri.uri:uri-port server-uri) :path
                            (str:concat (quri.uri:uri-path server-uri)
                                        (str:concat "/api/v1/collections/"
                                                    collection-id "/delete"))
                            :query
                            (openapi-generator::remove-empty-values
                             (when query query))))
            :content
            (cond
             (content
              (if (not
                   (stringp
                    (serapeum:assuref content
                                      (or openapi-generator::json-object
                                          hash-table))))
                  (com.inuoe.jzon:stringify content)
                  content))
             (delete-embedding
              (if (not
                   (stringp
                    (serapeum:assuref delete-embedding
                                      (or openapi-generator::json-object
                                          hash-table))))
                  (com.inuoe.jzon:stringify delete-embedding)
                  delete-embedding))
             ((or ids where where-document)
              (let ((openapi-generator::s (make-string-output-stream)))
                (declare (stream openapi-generator::s))
                (com.inuoe.jzon:with-writer* (:stream openapi-generator::s
                                              :pretty t)
                  (com.inuoe.jzon:with-object*
                    (when ids
                      (com.inuoe.jzon:write-key* "ids")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref ids
                                         (or openapi-generator::json-array
                                             list))))
                    (when where
                      (com.inuoe.jzon:write-key* "where")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref where
                                         (or openapi-generator::json-object
                                             hash-table))))
                    (when where-document
                      (com.inuoe.jzon:write-key* "where_document")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref where-document
                                         (or openapi-generator::json-object
                                             hash-table))))))
                (let ((openapi-generator::output
                       (get-output-stream-string openapi-generator::s)))
                  (declare (string openapi-generator::output))
                  (unless (string= "{}" openapi-generator::output)
                    openapi-generator::output)))))
            :method 'post :headers
            (openapi-generator::remove-empty-values
             (append
              (list (cons "Content-Type" "application/json")
                    (cons "Authorization" authorization)
                    (cons "cookie" cookie))
              (when headers headers))))))
     (if parse
         (com.inuoe.jzon:parse response)
         response)))
 (defun post/api/v1/collections/{collection_id}/get
        (collection-id
         &key (query *query*) (headers *headers*) (cookie *cookie*)
         (authorization *authorization*) (server *server*) (parse *parse*)
         get-embedding ids where where-document sort limit offset include
         content)
   "Operation-id: get
Summary: Get"
   (serapeum:assuref collection-id string)
   (let* ((server-uri (quri.uri:uri (or server "")))
          (response
           (dexador.backend.usocket:request
            (quri:render-uri
             (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                            (quri.uri:uri-host server-uri) :port
                            (quri.uri:uri-port server-uri) :path
                            (str:concat (quri.uri:uri-path server-uri)
                                        (str:concat "/api/v1/collections/"
                                                    collection-id "/get"))
                            :query
                            (openapi-generator::remove-empty-values
                             (when query query))))
            :content
            (cond
             (content
              (if (not
                   (stringp
                    (serapeum:assuref content
                                      (or openapi-generator::json-object
                                          hash-table))))
                  (com.inuoe.jzon:stringify content)
                  content))
             (get-embedding
              (if (not
                   (stringp
                    (serapeum:assuref get-embedding
                                      (or openapi-generator::json-object
                                          hash-table))))
                  (com.inuoe.jzon:stringify get-embedding)
                  get-embedding))
             ((or ids where where-document sort limit offset include)
              (let ((openapi-generator::s (make-string-output-stream)))
                (declare (stream openapi-generator::s))
                (com.inuoe.jzon:with-writer* (:stream openapi-generator::s
                                              :pretty t)
                  (com.inuoe.jzon:with-object*
                    (when ids
                      (com.inuoe.jzon:write-key* "ids")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref ids
                                         (or openapi-generator::json-array
                                             list))))
                    (when where
                      (com.inuoe.jzon:write-key* "where")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref where
                                         (or openapi-generator::json-object
                                             hash-table))))
                    (when where-document
                      (com.inuoe.jzon:write-key* "where_document")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref where-document
                                         (or openapi-generator::json-object
                                             hash-table))))
                    (when sort
                      (com.inuoe.jzon:write-key* "sort")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref sort string)))
                    (when limit
                      (com.inuoe.jzon:write-key* "limit")
                      (com.inuoe.jzon:write-value* (serapeum:assuref limit t)))
                    (when offset
                      (com.inuoe.jzon:write-key* "offset")
                      (com.inuoe.jzon:write-value* (serapeum:assuref offset t)))
                    (when include
                      (com.inuoe.jzon:write-key* "include")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref include
                                         (or openapi-generator::json-array
                                             list))))))
                (let ((openapi-generator::output
                       (get-output-stream-string openapi-generator::s)))
                  (declare (string openapi-generator::output))
                  (unless (string= "{}" openapi-generator::output)
                    openapi-generator::output)))))
            :method 'post :headers
            (openapi-generator::remove-empty-values
             (append
              (list (cons "Content-Type" "application/json")
                    (cons "Authorization" authorization)
                    (cons "cookie" cookie))
              (when headers headers))))))
     (if parse
         (com.inuoe.jzon:parse response)
         response)))
 (defun post/api/v1/collections/{collection_id}/upsert
        (collection-id
         &key (query *query*) (headers *headers*) (cookie *cookie*)
         (authorization *authorization*) (server *server*) (parse *parse*)
         add-embedding embeddings metadatas documents ids content)
   "Operation-id: upsert
Summary: Upsert"
   (serapeum:assuref collection-id string)
   (let* ((server-uri (quri.uri:uri (or server "")))
          (response
           (dexador.backend.usocket:request
            (quri:render-uri
             (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                            (quri.uri:uri-host server-uri) :port
                            (quri.uri:uri-port server-uri) :path
                            (str:concat (quri.uri:uri-path server-uri)
                                        (str:concat "/api/v1/collections/"
                                                    collection-id "/upsert"))
                            :query
                            (openapi-generator::remove-empty-values
                             (when query query))))
            :content
            (cond
             (content
              (if (not
                   (stringp
                    (serapeum:assuref content
                                      (or openapi-generator::json-object
                                          hash-table))))
                  (com.inuoe.jzon:stringify content)
                  content))
             (add-embedding
              (if (not
                   (stringp
                    (serapeum:assuref add-embedding
                                      (or openapi-generator::json-object
                                          hash-table))))
                  (com.inuoe.jzon:stringify add-embedding)
                  add-embedding))
             ((or embeddings metadatas documents ids)
              (let ((openapi-generator::s (make-string-output-stream)))
                (declare (stream openapi-generator::s))
                (com.inuoe.jzon:with-writer* (:stream openapi-generator::s
                                              :pretty t)
                  (com.inuoe.jzon:with-object*
                    (when embeddings
                      (com.inuoe.jzon:write-key* "embeddings")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref embeddings
                                         (or openapi-generator::json-array
                                             list))))
                    (when metadatas
                      (com.inuoe.jzon:write-key* "metadatas")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref metadatas
                                         (or openapi-generator::json-array
                                             list))))
                    (when documents
                      (com.inuoe.jzon:write-key* "documents")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref documents
                                         (or openapi-generator::json-array
                                             list))))
                    (com.inuoe.jzon:write-key* "ids")
                    (com.inuoe.jzon:write-value*
                     (progn
                      (serapeum:assuref ids
                                        (or openapi-generator::json-array
                                            list))
                      (or (ignore-errors (com.inuoe.jzon:parse ids)) ids)))))
                (let ((openapi-generator::output
                       (get-output-stream-string openapi-generator::s)))
                  (declare (string openapi-generator::output))
                  (unless (string= "{}" openapi-generator::output)
                    openapi-generator::output)))))
            :method 'post :headers
            (openapi-generator::remove-empty-values
             (append
              (list (cons "Content-Type" "application/json")
                    (cons "Authorization" authorization)
                    (cons "cookie" cookie))
              (when headers headers))))))
     (if parse
         (com.inuoe.jzon:parse response)
         response)))
 (defun post/api/v1/collections/{collection_id}/update
        (collection-id
         &key (query *query*) (headers *headers*) (cookie *cookie*)
         (authorization *authorization*) (server *server*) (parse *parse*)
         update-embedding embeddings metadatas documents ids content)
   "Operation-id: update
Summary: Update"
   (serapeum:assuref collection-id string)
   (let* ((server-uri (quri.uri:uri (or server "")))
          (response
           (dexador.backend.usocket:request
            (quri:render-uri
             (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                            (quri.uri:uri-host server-uri) :port
                            (quri.uri:uri-port server-uri) :path
                            (str:concat (quri.uri:uri-path server-uri)
                                        (str:concat "/api/v1/collections/"
                                                    collection-id "/update"))
                            :query
                            (openapi-generator::remove-empty-values
                             (when query query))))
            :content
            (cond
             (content
              (if (not
                   (stringp
                    (serapeum:assuref content
                                      (or openapi-generator::json-object
                                          hash-table))))
                  (com.inuoe.jzon:stringify content)
                  content))
             (update-embedding
              (if (not
                   (stringp
                    (serapeum:assuref update-embedding
                                      (or openapi-generator::json-object
                                          hash-table))))
                  (com.inuoe.jzon:stringify update-embedding)
                  update-embedding))
             ((or embeddings metadatas documents ids)
              (let ((openapi-generator::s (make-string-output-stream)))
                (declare (stream openapi-generator::s))
                (com.inuoe.jzon:with-writer* (:stream openapi-generator::s
                                              :pretty t)
                  (com.inuoe.jzon:with-object*
                    (when embeddings
                      (com.inuoe.jzon:write-key* "embeddings")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref embeddings
                                         (or openapi-generator::json-array
                                             list))))
                    (when metadatas
                      (com.inuoe.jzon:write-key* "metadatas")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref metadatas
                                         (or openapi-generator::json-array
                                             list))))
                    (when documents
                      (com.inuoe.jzon:write-key* "documents")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref documents
                                         (or openapi-generator::json-array
                                             list))))
                    (com.inuoe.jzon:write-key* "ids")
                    (com.inuoe.jzon:write-value*
                     (progn
                      (serapeum:assuref ids
                                        (or openapi-generator::json-array
                                            list))
                      (or (ignore-errors (com.inuoe.jzon:parse ids)) ids)))))
                (let ((openapi-generator::output
                       (get-output-stream-string openapi-generator::s)))
                  (declare (string openapi-generator::output))
                  (unless (string= "{}" openapi-generator::output)
                    openapi-generator::output)))))
            :method 'post :headers
            (openapi-generator::remove-empty-values
             (append
              (list (cons "Content-Type" "application/json")
                    (cons "Authorization" authorization)
                    (cons "cookie" cookie))
              (when headers headers))))))
     (if parse
         (com.inuoe.jzon:parse response)
         response)))
 (defun post/api/v1/collections/{collection_id}/add
        (collection-id
         &key (query *query*) (headers *headers*) (cookie *cookie*)
         (authorization *authorization*) (server *server*) (parse *parse*)
         add-embedding embeddings metadatas documents ids content)
   "Operation-id: add
Summary: Add"
   (serapeum:assuref collection-id string)
   (let* ((server-uri (quri.uri:uri (or server "")))
          (response
           (dexador.backend.usocket:request
            (quri:render-uri
             (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                            (quri.uri:uri-host server-uri) :port
                            (quri.uri:uri-port server-uri) :path
                            (str:concat (quri.uri:uri-path server-uri)
                                        (str:concat "/api/v1/collections/"
                                                    collection-id "/add"))
                            :query
                            (openapi-generator::remove-empty-values
                             (when query query))))
            :content
            (cond
             (content
              (if (not
                   (stringp
                    (serapeum:assuref content
                                      (or openapi-generator::json-object
                                          hash-table))))
                  (com.inuoe.jzon:stringify content)
                  content))
             (add-embedding
              (if (not
                   (stringp
                    (serapeum:assuref add-embedding
                                      (or openapi-generator::json-object
                                          hash-table))))
                  (com.inuoe.jzon:stringify add-embedding)
                  add-embedding))
             ((or embeddings metadatas documents ids)
              (let ((openapi-generator::s (make-string-output-stream)))
                (declare (stream openapi-generator::s))
                (com.inuoe.jzon:with-writer* (:stream openapi-generator::s
                                              :pretty t)
                  (com.inuoe.jzon:with-object*
                    (when embeddings
                      (com.inuoe.jzon:write-key* "embeddings")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref embeddings
                                         (or openapi-generator::json-array
                                             list))))
                    (when metadatas
                      (com.inuoe.jzon:write-key* "metadatas")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref metadatas
                                         (or openapi-generator::json-array
                                             list))))
                    (when documents
                      (com.inuoe.jzon:write-key* "documents")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref documents
                                         (or openapi-generator::json-array
                                             list))))
                    (com.inuoe.jzon:write-key* "ids")
                    (com.inuoe.jzon:write-value*
                     (progn
                      (serapeum:assuref ids
                                        (or openapi-generator::json-array
                                            list))
                      (or (ignore-errors (com.inuoe.jzon:parse ids)) ids)))))
                (let ((openapi-generator::output
                       (get-output-stream-string openapi-generator::s)))
                  (declare (string openapi-generator::output))
                  (unless (string= "{}" openapi-generator::output)
                    openapi-generator::output)))))
            :method 'post :headers
            (openapi-generator::remove-empty-values
             (append
              (list (cons "Content-Type" "application/json")
                    (cons "Authorization" authorization)
                    (cons "cookie" cookie))
              (when headers headers))))))
     (if parse
         (com.inuoe.jzon:parse response)
         response)))
 (defun post/api/v1/collections
        (
         &key (query *query*) (headers *headers*) (cookie *cookie*)
         (authorization *authorization*) (server *server*) (parse *parse*)
         create-collection name metadata get-or-create content)
   "Operation-id: create-collection
Summary: Create Collection"
   (let* ((server-uri (quri.uri:uri (or server "")))
          (response
           (dexador.backend.usocket:request
            (quri:render-uri
             (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                            (quri.uri:uri-host server-uri) :port
                            (quri.uri:uri-port server-uri) :path
                            (str:concat (quri.uri:uri-path server-uri)
                                        "/api/v1/collections")
                            :query
                            (openapi-generator::remove-empty-values
                             (when query query))))
            :content
            (cond
             (content
              (if (not
                   (stringp
                    (serapeum:assuref content
                                      (or openapi-generator::json-object
                                          hash-table))))
                  (com.inuoe.jzon:stringify content)
                  content))
             (create-collection
              (if (not
                   (stringp
                    (serapeum:assuref create-collection
                                      (or openapi-generator::json-object
                                          hash-table))))
                  (com.inuoe.jzon:stringify create-collection)
                  create-collection))
             ((or name metadata get-or-create)
              (let ((openapi-generator::s (make-string-output-stream)))
                (declare (stream openapi-generator::s))
                (com.inuoe.jzon:with-writer* (:stream openapi-generator::s
                                              :pretty t)
                  (com.inuoe.jzon:with-object*
                    (com.inuoe.jzon:write-key* "name")
                    (com.inuoe.jzon:write-value*
                     (progn
                      (serapeum:assuref name string)
                      (or (ignore-errors (com.inuoe.jzon:parse name)) name)))
                    (when metadata
                      (com.inuoe.jzon:write-key* "metadata")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref metadata
                                         (or openapi-generator::json-object
                                             hash-table))))
                    (when get-or-create
                      (com.inuoe.jzon:write-key* "get_or_create")
                      (com.inuoe.jzon:write-value*
                       (serapeum:assuref get-or-create
                                         (or openapi-generator::json-true
                                             openapi-generator::json-false null
                                             t))))))
                (let ((openapi-generator::output
                       (get-output-stream-string openapi-generator::s)))
                  (declare (string openapi-generator::output))
                  (unless (string= "{}" openapi-generator::output)
                    openapi-generator::output)))))
            :method 'post :headers
            (openapi-generator::remove-empty-values
             (append
              (list (cons "Content-Type" "application/json")
                    (cons "Authorization" authorization)
                    (cons "cookie" cookie))
              (when headers headers))))))
     (if parse
         (com.inuoe.jzon:parse response)
         response)))
 (defun get/api/v1/collections
        (
         &key (query *query*) (headers *headers*) (cookie *cookie*)
         (authorization *authorization*) (server *server*) (parse *parse*))
   "Operation-id: list-collections
Summary: List Collections"
   (let* ((server-uri (quri.uri:uri (or server "")))
          (response
           (dexador.backend.usocket:request
            (quri:render-uri
             (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                            (quri.uri:uri-host server-uri) :port
                            (quri.uri:uri-port server-uri) :path
                            (str:concat (quri.uri:uri-path server-uri)
                                        "/api/v1/collections")
                            :query
                            (openapi-generator::remove-empty-values
                             (when query query))))
            :method 'get :headers
            (openapi-generator::remove-empty-values
             (append
              (list (cons "Authorization" authorization)
                    (cons "cookie" cookie))
              (when headers headers))))))
     (if parse
         (com.inuoe.jzon:parse response)
         response)))
 (defun get/api/v1/pre-flight-checks
        (
         &key (query *query*) (headers *headers*) (cookie *cookie*)
         (authorization *authorization*) (server *server*) (parse *parse*))
   "Operation-id: pre-flight-checks
Summary: Pre Flight Checks"
   (let* ((server-uri (quri.uri:uri (or server "")))
          (response
           (dexador.backend.usocket:request
            (quri:render-uri
             (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                            (quri.uri:uri-host server-uri) :port
                            (quri.uri:uri-port server-uri) :path
                            (str:concat (quri.uri:uri-path server-uri)
                                        "/api/v1/pre-flight-checks")
                            :query
                            (openapi-generator::remove-empty-values
                             (when query query))))
            :method 'get :headers
            (openapi-generator::remove-empty-values
             (append
              (list (cons "Authorization" authorization)
                    (cons "cookie" cookie))
              (when headers headers))))))
     (if parse
         (com.inuoe.jzon:parse response)
         response)))
 (defun get/api/v1/heartbeat
        (
         &key (query *query*) (headers *headers*) (cookie *cookie*)
         (authorization *authorization*) (server *server*) (parse *parse*))
   "Operation-id: heartbeat
Summary: Heartbeat"
   (let* ((server-uri (quri.uri:uri (or server "")))
          (response
           (dexador.backend.usocket:request
            (quri:render-uri
             (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                            (quri.uri:uri-host server-uri) :port
                            (quri.uri:uri-port server-uri) :path
                            (str:concat (quri.uri:uri-path server-uri)
                                        "/api/v1/heartbeat")
                            :query
                            (openapi-generator::remove-empty-values
                             (when query query))))
            :method 'get :headers
            (openapi-generator::remove-empty-values
             (append
              (list (cons "Authorization" authorization)
                    (cons "cookie" cookie))
              (when headers headers))))))
     (if parse
         (com.inuoe.jzon:parse response)
         response)))
 (defun get/api/v1/version
        (
         &key (query *query*) (headers *headers*) (cookie *cookie*)
         (authorization *authorization*) (server *server*) (parse *parse*))
   "Operation-id: version
Summary: Version"
   (let* ((server-uri (quri.uri:uri (or server "")))
          (response
           (dexador.backend.usocket:request
            (quri:render-uri
             (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                            (quri.uri:uri-host server-uri) :port
                            (quri.uri:uri-port server-uri) :path
                            (str:concat (quri.uri:uri-path server-uri)
                                        "/api/v1/version")
                            :query
                            (openapi-generator::remove-empty-values
                             (when query query))))
            :method 'get :headers
            (openapi-generator::remove-empty-values
             (append
              (list (cons "Authorization" authorization)
                    (cons "cookie" cookie))
              (when headers headers))))))
     (if parse
         (com.inuoe.jzon:parse response)
         response)))
 (defun post/api/v1/reset
        (
         &key (query *query*) (headers *headers*) (cookie *cookie*)
         (authorization *authorization*) (server *server*) (parse *parse*))
   "Operation-id: reset
Summary: Reset"
   (let* ((server-uri (quri.uri:uri (or server "")))
          (response
           (dexador.backend.usocket:request
            (quri:render-uri
             (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                            (quri.uri:uri-host server-uri) :port
                            (quri.uri:uri-port server-uri) :path
                            (str:concat (quri.uri:uri-path server-uri)
                                        "/api/v1/reset")
                            :query
                            (openapi-generator::remove-empty-values
                             (when query query))))
            :method 'post :headers
            (openapi-generator::remove-empty-values
             (append
              (list (cons "Authorization" authorization)
                    (cons "cookie" cookie))
              (when headers headers))))))
     (if parse
         (com.inuoe.jzon:parse response)
         response)))
 (defun get/api/v1
        (
         &key (query *query*) (headers *headers*) (cookie *cookie*)
         (authorization *authorization*) (server *server*) (parse *parse*))
   "Operation-id: root
Summary: Root"
   (let* ((server-uri (quri.uri:uri (or server "")))
          (response
           (dexador.backend.usocket:request
            (quri:render-uri
             (quri:make-uri :scheme (quri.uri:uri-scheme server-uri) :host
                            (quri.uri:uri-host server-uri) :port
                            (quri.uri:uri-port server-uri) :path
                            (str:concat (quri.uri:uri-path server-uri)
                                        "/api/v1")
                            :query
                            (openapi-generator::remove-empty-values
                             (when query query))))
            :method 'get :headers
            (openapi-generator::remove-empty-values
             (append
              (list (cons "Authorization" authorization)
                    (cons "cookie" cookie))
              (when headers headers))))))
     (if parse
         (com.inuoe.jzon:parse response)
         response)))
 (setf (fdefinition 'update-collection)
        (fdefinition 'put/api/v1/collections/{collection_id})
      (fdefinition 'get-collection)
        (fdefinition 'get/api/v1/collections/{collection_name})
      (fdefinition 'delete-collection)
        (fdefinition 'delete/api/v1/collections/{collection_name})
      (fdefinition 'get-nearest-neighbors)
        (fdefinition 'post/api/v1/collections/{collection_id}/query)
      (fdefinition 'count)
        (fdefinition 'get/api/v1/collections/{collection_id}/count)
      (fdefinition 'delete)
        (fdefinition 'post/api/v1/collections/{collection_id}/delete)
      (fdefinition 'get)
        (fdefinition 'post/api/v1/collections/{collection_id}/get)
      (fdefinition 'upsert)
        (fdefinition 'post/api/v1/collections/{collection_id}/upsert)
      (fdefinition 'update)
        (fdefinition 'post/api/v1/collections/{collection_id}/update)
      (fdefinition 'add)
        (fdefinition 'post/api/v1/collections/{collection_id}/add)
      (fdefinition 'list-collections) (fdefinition 'get/api/v1/collections)
      (fdefinition 'create-collection) (fdefinition 'post/api/v1/collections)
      (fdefinition 'pre-flight-checks)
        (fdefinition 'get/api/v1/pre-flight-checks)
      (fdefinition 'heartbeat) (fdefinition 'get/api/v1/heartbeat)
      (fdefinition 'version) (fdefinition 'get/api/v1/version)
      (fdefinition 'reset) (fdefinition 'post/api/v1/reset)
      (fdefinition 'root) (fdefinition 'get/api/v1))
