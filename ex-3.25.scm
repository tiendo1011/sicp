(load "arbitrary-dimentional-table.scm")

(define operation-table (make-table))
(insert! operation-table 'value '1key)
(lookup operation-table '1key)

(insert! operation-table 'value '2key-1 '2key-2)
(lookup operation-table '2key-1 '2key-2)

(insert! operation-table 'value '3key-1 '3key-2 '3key-3)
(lookup operation-table '3key-1 '3key-2 '3key-3)
