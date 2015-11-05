;;;;;;;;;;;;;;;;;;;;;;;;;; Funçoes do problema de procura 2.2.1 ;;;;;;;;;;;;;;;;
;;PECAS: I J L O S Z T
;; Devolve logico
(defun solucao (estado)
  (and (not (tabuleiro-topo-preenchido-p estado-tabuleiro))
       (null estado-pecas-por-colocar)))

;; Devolve lista accoes: estado
(defun accoes ()
  (setf lista '())
   (dolist (el (pecas_possiveis 'i))
      (dotimes (k (- 10 (array-dimension el 1)))
               (append '(k) lista)))
   lista)

;; Devolve estado
(defun resultado (estado_in accao)
  (let (( coluna (accao-coluna accao))
        ( coluna_aux (accao-coluna accao))
        ( peca   (accao-peca accao))
        )
  (print accao)
  (print '() )
  (setf dimensoes_peca (array-dimensions peca))
  (setf max (list 0 coluna))
  (setf lst_contorno_peca '())
  (loop for j from (1- (second dimensoes_peca)) downto 0 do
    (dotimes (n (first dimensoes_peca))
        (when (aref peca n j)(progn (push n lst_contorno_peca) (return T)))
    )
  )
  lst_contorno_peca

  (setf tabuleiro_criado (copia-tabuleiro (estado-tabuleiro estado_in)))


  (dolist (elem lst_contorno_peca max)

      (setf valor_calc (- (tabuleiro-altura-coluna tabuleiro_criado coluna_aux) elem))
      (cond ((< (first max) valor_calc) (setf max (list valor_calc coluna_aux))))

      (incf coluna_aux)
  )
  (setf difference (- (second max) coluna))
  (setf base_writing_x (- (first max) (nth difference lst_contorno_peca)))
  (setf base_writing_y coluna)
  (dotimes (n (first dimensoes_peca))
    (setf writing_x (+ base_writing_x N))
    (dotimes (i (second dimensoes_peca))
      (setf writing_y (+ base_writing_y i))

      (cond ((aref peca n i) (tabuleiro-preenche! tabuleiro_criado writing_x writing_y))
      )
    )
  )



  (setf new-points 50)

  (make-estado :pontos new-points
               :pecas-por-colocar (rest (estado-pecas-por-colocar estado_in))
               :pecas-colocadas (push (first (estado-pecas-por-colocar estado_in))(estado-pecas-colocadas estado_in))
               :tabuleiro tabuleiro_criado)
  ))

;(setf estad (make-estado :pontos 100 :pecas-por-colocar '('i 'j 'l) :pecas-colocadas '('z) :tabuleiro (cria-tabuleiro)))
;(setf accao (cria-accao 5 peca-j2))
;(desenha-estado (resultado estad accao))


;; Devolve inteiro
(defun qualidade (estado_in)
  (- (estado-pontos estado_in))
)

;; Devolve inteiro
(defun custo-opurtonidade (estado))


;; Devolve uma lista com as possiveis pecas rodadas
(defun pecas_possiveis (peca)
  (cond ((equal peca 'i) '(peca-i0 peca-i1))
        ((equal peca 'l) '(peca-l0 peca-l1 peca-l2 peca-l3))
        ((equal peca 'j) '(peca-j0 peca-j1 peca-j2 peca-j3))
        ((equal peca 'o) '(peca-o0))
        ((equal peca 's) '(peca-s0 peca-s1))
        ((equal peca 'z) '(peca-z0 peca-z1))
        ((equal peca 't) '(peca-t0 peca-t1 peca-t2 peca-t3))
  ))
