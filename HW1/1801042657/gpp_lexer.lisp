(defun operator (str)
    (cond
        ((string= str "+") (write "OP_PLUS"))
        ((string= str "-") (write "OP_MINUS"))
        ((string= str "/") (write "OP_DIV"))
        ((string= str "//") (write "OP_DIV2"))
        ((string= str "(") (write "OP_OP"))
        ((string= str ")") (write "OP_CP"))
        ((string= str "\"") (write "OP_OC"))
        ((string= str ",") (write "OP_COMMA"))
        ((string= str "**") (write "OP_DBLMULT"))
        ((string= str "*") (write "OP_MULT"))
        (t nil)
    )
)


(defun keyword (str)
    (setf dc_str (string-downcase str))
    (cond
        ((string= dc_str "and") (write "KW_AND"))
        ((string= dc_str "or") (write "KW_OR"))
        ((string= dc_str "not") (write "KW_NOT"))
        ((string= dc_str "equal") (write "KW_EQUAL"))
        ((string= dc_str "less") (write "KW_LESS"))
        ((string= dc_str "nil") (write "KW_NIL"))
        ((string= dc_str "list") (write "KW_LIST"))
        ((string= dc_str "append") (write "KW_APPEND"))
        ((string= dc_str "concat") (write "KW_CONCAT"))
        ((string= dc_str "set") (write "KW_SET"))
        ((string= dc_str "deffun") (write "KW_DEFFUN"))
        ((string= dc_str "for") (write "KW_FOR"))
        ((string= dc_str "if") (write "KW_IF"))
        ((string= dc_str "exit") (write "KW_EXIT"))
        ((string= dc_str "load") (write "KW_LOAD"))
        ((string= dc_str "disp") (write "KW_DISP"))
        ((string= dc_str "true") (write "KW_TRUE"))
        ((string= dc_str "false") (write "KW_FALSE"))
        (t nil)
    )
)



(defun func()
    
    (defvar i 0)
    (loop
       	(setq line (read-line))
        (setq size (length line))
        (loop for i from 1 to size do
          (setq chr (subseq line 0 i))
          (operator chr)
          (keyword chr)
          (setq i (+ i 1))
        )
        (terpri)
        (if (string= line "exit") (return))
        (if (string= line "(exit)") (return))
    )
)


(func)
