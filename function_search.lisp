;;;;;;;;;;;;;;;;;;;;;;;;;; Funcoes do problema de procura 2.2.1 ;;;;;;;;;;;;;;;;
;;PECAS: I J L O S Z T
;; Devolve logico
(defun solucao (estado)
  (and (not (tabuleiro-topo-preenchido-p estado-tabuleiro))
       (null (estado-pecas-por-colocar estado))))

;; Devolve lista accoes: estado
(defun accoes (estado_in)
  (setf lista (list))
   (dolist (el (pecas_possiveis (first estado-pecas-por-colocar estado_in)))
      (loop for k from (- 10 (array-dimension el 1)) downto 0
      do (push (cria-accao k el) lista)))
   lista)

;; Devolve estado
(defun resultado (estado_in accao)
  (let (( coluna (accao-coluna accao))
        ( coluna_aux (accao-coluna accao))
        ( peca   (accao-peca accao))
        )
  (setf dimensoes_peca (array-dimensions peca))
  (setf max (list 0 coluna))
  (setf lst_contorno_peca '())
  (loop for j from (1- (second dimensoes_peca)) downto 0 do
    (dotimes (n (first dimensoes_peca))
        (when (aref peca n j)(progn (push n lst_contorno_peca) (return T)))
    )
  )
  ;; Copiar tabuleiro novo
  (setf tabuleiro_criado (copia-tabuleiro (estado-tabuleiro estado_in)))

  ;; Calcular posicao de escrita
  (dolist (elem lst_contorno_peca max)
      (setf valor_calc (- (tabuleiro-altura-coluna tabuleiro_criado coluna_aux) elem))
      (cond ((< (first max) valor_calc) (setf max (list valor_calc coluna_aux))))

      (incf coluna_aux))

  (setf difference (- (second max) coluna))
  (setf base_writing_x (- (first max) (nth difference lst_contorno_peca)))
  (setf base_writing_y coluna)

  ;;Colocar peca no tabuleiro
  (dotimes (n (first dimensoes_peca))
    (setf writing_x (+ base_writing_x N))
    (dotimes (i (second dimensoes_peca))
      (setf writing_y (+ base_writing_y i))

      (cond ((aref peca n i) (tabuleiro-preenche! tabuleiro_criado writing_x writing_y))
      )
    )
  )
  ;;Verificar se perdeu o jogo
  (if (tabuleiro-topo-preenchido-p tabuleiro_criado) () ;;perdeu o jogo
                ;;else verificar linhas preenchidas
                (progn
                (setf real_cut base_writing_x)
                (setf max 0)
                (loop for aux from base_writing_x to (1+ writing_x) do
                      (progn
                          (setf max aux)
                          (if (tabuleiro-linha-completa-p tabuleiro_criado real_cut)
                                (tabuleiro-remove-linha! tabuleiro_criado real_cut)
                                (incf real_cut))
                      )

                )
                (decf real_cut)
                )
  )
  (setf dif_linhas (- max real_cut))
  (setf new-points (estado-pontos estado_in))
  (cond
      ((= dif_linhas 0) T)
      ((= dif_linhas 1) (setf new-points (+ new-points 100)) )
      ((= dif_linhas 2) (setf new-points (+ new-points 300)) )
      ((= dif_linhas 3) (setf new-points (+ new-points 500)) )
      ((= dif_linhas 4) (setf new-points (+ new-points 800)) )
   )


  ;; Criar novo estado + atualizar listas
  (make-estado :pontos new-points
               :pecas-por-colocar (rest (estado-pecas-por-colocar estado_in))
               :pecas-colocadas (push (first (estado-pecas-por-colocar estado_in))(estado-pecas-colocadas estado_in))
               :tabuleiro tabuleiro_criado)
))


;; Devolve inteiro
(defun qualidade (estado_in)
  (- (estado-pontos estado_in))
)

;; Devolve inteiro
(defun custo-oportunidade (estado_in)
  (let ((lista_colocadas (estado-pecas-colocadas estado_in))
        (valor_oportunidade 0)
        (valor_real (estado-pontos estado_in)))

      ;;Calcular valor_oportunidade
      (dolist (elem lista_colocadas)
        (
        progn
        (cond ((eq elem 'I) (incf valor_oportunidade 800))
              ((eq elem 'J) (incf valor_oportunidade 500))
              ((eq elem 'L) (incf valor_oportunidade 500))
              ((eq elem 'S) (incf valor_oportunidade 300))
              ((eq elem 'Z) (incf valor_oportunidade 300))
              ((eq elem 'T) (incf valor_oportunidade 300))
              ((eq elem 'O) (incf valor_oportunidade 300))))
      )
      (- valor_oportunidade valor_real)))


;; Devolve uma lista com as possiveis pecas rodadas
(defun pecas_possiveis (peca)
  (cond ((equal peca 'i) (list peca-i1 peca-i0))
        ((equal peca 'l) (list peca-l3 peca-l2 peca-l1 peca-l0))
        ((equal peca 'j) (list peca-j3 peca-j2 peca-j1 peca-j0))
        ((equal peca 'o) (list peca-o0))
        ((equal peca 's) (list peca-s1 peca-s0))
        ((equal peca 'z) (list peca-z1 peca-z0))
        ((equal peca 't) (list peca-t3 peca-t2 peca-t1 peca-t0))
  ))
