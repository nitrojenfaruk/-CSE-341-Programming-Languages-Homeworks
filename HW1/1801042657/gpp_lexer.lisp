
(defvar *open_quote* 0)
(defvar *flag* 0)
(defvar *terminal_flag* 0)
(defvar *comment_flag* 0)


(defun is-alpha (chr)
    (or (and (char>= chr #\A) (char<= chr #\Z)) (and (char>= chr #\a) (char<= chr #\z)))
)

(defun is-digit (chr)
    (and (char>= chr #\0) (char<= chr #\9))
)

(defun is-alnum (chr)
    (or (is-digit chr) (is-alpha chr))
)



(defun keyword_pairlist ()
    (pairlis '("false" "true" "disp"  "load" "exit" "if" "for" "deffun" "set" "concat" "append" "list" "nil" "less" "equal" "not" "or" "and")
        '("KW_FALSE" "KW_TRUE" "KW_DISP" "KW_LOAD" "KW_EXIT" "KW_IF" "KW_FOR" "KW_DEFFUN" "KW_SET" "KW_CONCAT" "KW_APPEND" "KW_LIST" "KW_NIL" "KW_LESS" "KW_EQUAL" "KW_NOT" "KW_OR" "KW_AND"))
)

(defun operator_pairlist ()
    (pairlis '("," "\"" "\"" "**" ")" "(" "*" "/" "-" "+")
        '("OP_COMMA" "OP_CC" "OP_OC" "OP_DBLMULT" "OP_CP" "OP_OP" "OP_MULT" "OP_DIV" "OP_MINUS" "OP_PLUS"))
)


(defun concat_pairlists ()
    (concatenate 'list (keyword_pairlist) (operator_pairlist))
)


(defun tokenize (token pair_list)

    (let ((value))
        (if (or
            (setf value (tokenize_keyword_op token pair_list))
            (setf value (tokenize_identifier token))
            (setf value (tokenize_value token))
            (setf value (tokenize_comment token)))
            value (format nil "SYNTAX ERROR ~a cannot be tokenized" token)
        )
    )

)


(defun tokenize_keyword_op (token pairlist)
    
    (let ((var (assoc token pairlist :test #'string-equal)))
        
        (if (string= (car var) "\"")
            
            (if (zerop *open_quote*) 
                (progn 
                    (setf *open_quote* 1) "OP_OC"
                ) 
                (progn 
                    (setf *open_quote* 0) "OP_CC"
                )
            )
            (cdr var)
        )
    )
)


(defun tokenize_identifier (token) 
    
    (if (is-alpha (char token 0))
        
        (loop for i across token do 
            
            (when (not (is-alnum i)) 
                (return-from tokenize_identifier)
            )

        )
        (return-from tokenize_identifier)
    ) 
    "IDENTIFIER"

)

(defun tokenize_value (token) 
    
    (if (> (length token) 1)
        (when (and (char= (char token 0) #\0) (not (= (length token) 1))) 
            (return-from tokenize_value)
        )
    )

    (loop for i across token do 
        (when (not (is-digit i)) 
            (return-from tokenize_value)
        )
    )
    "VALUE"

)


(defun tokenize_comment (token)    ; ;  !!!!!!!!
    (when (and (>= (length token) 1) (char= (char token 0) #\;)) 
        "COMMENT"
    )
)



(defun lexer (word)

    (setq bound 0)
    (setq flag 0)
    (setq op_size 1)

    (setq o_list '("," "\"" "\"" "**" ")" "(" "*" "/" "-" "+"))    
    (setq k_list '("false" "true" "disp"  "load" "exit" "if" "for" "deffun" "set" "concat" "append" "list" "nil" "less" "equal" "not" "or" "and"))
    
    (if (and (= (length word) 1) (is-alnum (char word 0)))
        (write-line (tokenize word (concat_pairlists))) 
        ;(return-from lexer)

    )

    (if (and (= (length word) 2) (string-equal (char word 0) "*") (string-equal (char word 1) "*"))
        (progn
            (write-line (tokenize word (concat_pairlists))) 
            (return-from lexer)
        )
    )

    (if (and (>= (length word) 1) (string-equal (char word 0) ";") )
        (progn
            (setf *comment_flag* 1)
            (write-line (tokenize word (concat_pairlists))) 
            (return-from lexer)
        )
    )

    (if (= *comment_flag* 1)   ;; jumps current line
        (return-from lexer)
    )

    (loop for i in o_list do
        (if (> (length word) 1)
            (setq index_i (search i (subseq word 0 2)))
            (setq index_i (search i (subseq word 0 1)))
        )
        (if (string= (write-to-string index_i) "0")
            (progn 
                (if (string= i "**")
                    (setq op_size 2)
                )
                (setq flag 1)
            )
        )
     
    )

    (if (= flag 1) 
        (progn         
            (write-line (tokenize (subseq word 0 op_size) (concat_pairlists))) 
           
            (if (> (length word) 1)
                (progn 
                    (setf word (subseq word op_size))   
                    (if (not (is-alnum (char word 0)))
                        (progn
                            (lexer word)
                        )
                    )

                    (if (and (is-alnum (char word 0)) (= (length word) 1))
                        (lexer word)
                    )

                )    
                (return-from lexer)
            )
        )
    )

    (if (and(> (length word) 1) (is-alnum (char word 0)))
 
            (loop for j from 0 to (- (length word) 1) do

                (if (= j 256)
                    (return)
                )

                (incf bound) 

                (when (or (not (is-alnum (char word j))) (= (length word) bound))
                    
                    (if (not (is-alnum (char word j)))
                        (setq up_bound (- bound 1))
                        (setq up_bound bound)
                    ) 

                    (write-line (tokenize (subseq word 0 up_bound) (concat_pairlists))) 

                    (if (> (length word) up_bound)
                        (progn
                            (setf word (subseq word up_bound))
                            (setq j 256)
                            (lexer word)

                        )
                        (progn
                            (return-from lexer)   
                        ) 
                    )
                )
               
            )
    )

    
)




(defun mainFunction (line)

    (if (= (length line) 0)
        (return-from mainFunction)
    )


    (setq word_list '(nil))    

    (if (string= line "£")
        (progn
            (setq line (read-line))
            (setq *terminal_flag* 1)
        )
    )

    (setq ccc 0)

    (setq line (string-trim '(#\Space #\Newline #\Backspace #\Tab #\Linefeed #\Page #\Return #\Rubout) line))   ; bastaki ve sondaki boşlukları siler
    

    (setf line (concatenate 'string " " line " " ))    
    (setq j (length line))  


    (setf line (substitute #\Space #\Newline line))
    (setf line (substitute #\Space #\Backspace line))
    (setf line (substitute #\Space #\Tab line))
    (setf line (substitute #\Space #\Linefeed line))
    (setf line (substitute #\Space #\Page line))
    (setf line (substitute #\Space #\Return line))
    (setf line (substitute #\Space #\Rubout line))


    (setq i 0)
    (setq first_space 0)
    (setq last_space 0)
    (setq piece 1)
    (loop 
        (when (>= i (length line)) 
            (return i))
       
        (if (and (/= i (- j 1)) (/= i 0) (string-equal (char line i) " ") (string-not-equal (char line (+ i 1)) " ") )    ; case-insensitive comparison string-equal
            (progn
                (if (= piece 2)
                        (progn  ; piece == 2
                            (setf word (string-trim '(#\Space #\Tab #\Newline) (subseq line first_space i)))
                            (push word word_list)
                            (setq first_space i)
                        )
                        (progn  ; piece /= 2
                            (setf word (string-trim '(#\Space #\Tab #\Newline) (subseq line 0 i)))
                            (push word word_list)
                            (setq first_space i)
                            (incf piece)  
                        )
                )
            )
        )

        (if (= i (- j 1))
            (progn  ;i == j-1
                 (setf word (string-trim '(#\Space #\Tab #\Newline) (subseq line first_space j)))
                 (push word word_list)
            )
        )
        (incf i)
    )

    (setf word_list (reverse word_list))
    (setf word_list (remove nil word_list))
    
    (setq line (string-trim '(#\Space #\Tab #\Newline) line))   ; removing spaces from start and end

    (if (string-equal line "q")
        (return-from mainFunction) 
        (progn
            (loop for word in word_list do
                (if (= *comment_flag* 0) 
                    (lexer word)
                    (progn 
                        (if (= *terminal_flag* 0)
                            (progn
                                (setq *comment_flag* 0)
                                (return)
                            )
                        )
                    )
                )
               
            )
        )
    )

    (terpri)

    (if (= *terminal_flag* 1)
        (progn
            (setq *comment_flag* 0)
            (setf t_line (read-line))
            (mainFunction t_line)
        )
    )
)



(defun file_read (&optional file_name)

    (let ((in (open file_name :if-does-not-exist nil)))
        (when in
            (loop for f_line = (read-line in nil)
                while f_line do (mainFunction f_line)
            )
            (close in)
        )
    )

    (mainFunction "£")
)


(defun main ()

    (setf x (read-line))
    

    (if (and (string= x "gppinterpreter") (= (length x) 14))
        (file_read)
        (progn
            (if (and (>= (length x) 16) (string= (subseq x 0 14) "gppinterpreter"))
                (file_read (subseq x 15))
                (write "Wrong input! Please, write gppinterpreter or gppinterpreter file_name")
            )
        )
    )
)

(main)

