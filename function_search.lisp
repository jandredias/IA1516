;;;;;;;;;;;;;;;;;;;;;;;;;; Funçoes do problema de procura 2.2.1 ;;;;;;;;;;;;;;;;
;;PECAS: I J L O S Z T
;; Devolve logico
(defun solucao (estado)
  (and (not (tabuleiro-topo-preenchido-p estado-tabuleiro))
       (null estado-pecas-por-colocar)))

;; Devolve lista accoes
(defun accoes (estado)
  )

;; Devolve estado
(defun resultado (estado_in accao)
  (let (( coluna (accao-coluna accao))
        ( coluna_aux (accao-coluna accao))
        ( peca   (accao-peca accao))
        ( max '(0 0)))
  (setf dimensoes_peca (array-dimensions peca))

  (setf lst '())
  (print peca)
  (loop for j from (1- (second dimensoes_peca)) downto 0 do
    (dotimes (n (first dimensoes_peca))
        (print (list n j))
        (when (aref peca n j)(progn (push n lst) (return T)))
    )
  )
  lst

  (setf tabuleiro_criado (copia-tabuleiro (estado-tabuleiro estado_in)))

  (dolist (elem lst max)
      (print ELEM)
      (setf valor_calc (- (tabuleiro-altura-coluna tabuleiro_criado coluna_aux) elem))
      (print valor_calc)
      (cond ((< (first max) valor_calc) (setf max (list valor_calc coluna_aux))))
      (incf coluna_aux)
  )



  (setf new-points largura_peça)

  (make-estado :pontos new-points
               :pecas-por-colocar (rest (estado-pecas-por-colocar estado_in))
               :pecas-colocadas (push (first (estado-pecas-por-colocar estado_in))(estado-pecas-colocadas estado_in))
               :tabuleiro tabuleiro_criado)))

))
(setf estad (make-estado :pontos 100 :pecas-por-colocar '('i 'j 'l) :pecas-colocadas '('z) :tabuleiro (cria-tabuleiro)))
(setf accao (cria-accao 5 peca-z2))
(resultado estad accao)


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
