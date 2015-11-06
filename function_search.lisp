;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;; Funcoes do problema de procura 2.2.1 ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;PECAS: I J L O S Z T
;; Devolve logico
(defun solucao (estado_in)
  (and (not (tabuleiro-topo-preenchido-p (estado-tabuleiro estado_in)))
       (null (estado-pecas-por-colocar estado_in))))

;; Devolve lista accoes: estado
(defun accoes (estado_in)
  (let ((lista (list)))
   (dolist (el (pecas_possiveis (first (estado-pecas-por-colocar estado_in))))
      (loop for k from (- 10 (array-dimension el 1)) downto 0
      do (push (cria-accao k el) lista)))
   lista))

;; Devolve estado
(defun resultado (estado_in accao)
  (let* (( coluna (accao-coluna accao))
        ( coluna_aux (accao-coluna accao))
        ( peca   (accao-peca accao))
        ( dimensoes_peca (array-dimensions peca))
        ( max -10)
        ( lst_contorno_peca '())
        ( base_writing_x 0)
        ( base_writing_y 0)
        ( writing_x 0)
        ( writing_y 0)
        ( valor_calc 0)
        ( real_cut 0)
        ( dif_linhas 0)
        ( new-points 0)

        ;; Copiar tabuleiro novo
        ( tabuleiro_criado (copia-tabuleiro (estado-tabuleiro estado_in)) ))

  ;; Cria lista com alturas da peca
  (loop for j from (1- (second dimensoes_peca)) downto 0 do
    (dotimes (n (first dimensoes_peca))
        (when (aref peca n j)(progn (push n lst_contorno_peca) (return T)))
    )
  )

  ;; Calcular posicao de escrita
  (dolist (elem lst_contorno_peca max)
      (setf valor_calc (- (tabuleiro-altura-coluna tabuleiro_criado coluna_aux) elem))

      (cond ((< max valor_calc) (setf max valor_calc )))
      (incf coluna_aux))



  (setf base_writing_x max)
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

  (setf new-points (estado-pontos estado_in))

  ;;Verificar se perdeu o jogo
  (if (< writing_x 18)
    ;;Remover linhas preenchidas caso nao tenha perdido
    (progn
    (setf real_cut base_writing_x)
    (setf max 0)
    (loop for aux from base_writing_x to (1+ writing_x) do
          (progn
              (setf max aux)
              (if (tabuleiro-linha-completa-p tabuleiro_criado real_cut)
                    (tabuleiro-remove-linha! tabuleiro_criado real_cut)
                    (incf real_cut))))
    (decf real_cut)
    (setf dif_linhas (- max real_cut))
    (cond
        ((= dif_linhas 0) T)
        ((= dif_linhas 1) (setf new-points (+ new-points 100)) )
        ((= dif_linhas 2) (setf new-points (+ new-points 300)) )
        ((= dif_linhas 3) (setf new-points (+ new-points 500)) )
        ((= dif_linhas 4) (setf new-points (+ new-points 800)) )))
  T)
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
  (cond ((equal peca 'i) (list  (make-array (list 1 4) :initial-element T)
                                (make-array (list 4 1) :initial-element T)))
        ((equal peca 'l) (list  (make-array (list 2 3) :initial-contents '((T T T)(nil nil T)))
                                (make-array (list 3 2) :initial-contents '((nil T)(nil T)(T T)))
                                (make-array (list 2 3) :initial-contents '((T nil nil)(T T T)))
                                (make-array (list 3 2) :initial-contents '((T T)(T nil)(T nil)))))
        ((equal peca 'j) (list  (make-array (list 2 3) :initial-contents '((nil nil T)(T T T)))
                                (make-array (list 3 2) :initial-contents '((T nil)(T nil)(T T)))
                                (make-array (list 2 3) :initial-contents '((T T T)(T nil nil)))
                                (make-array (list 3 2) :initial-contents '((T T)(nil T)(nil T)))))
        ((equal peca 'o) (list  (make-array (list 2 2) :initial-element T)))
        ((equal peca 's) (list  (make-array (list 3 2) :initial-contents '((nil T)(T T)(T nil)))
                                (make-array (list 2 3) :initial-contents '((T T nil)(nil T T)))))
        ((equal peca 'z) (list  (make-array (list 3 2) :initial-contents '((T nil)(T T)(nil T)))
                                (make-array (list 2 3) :initial-contents '((nil T T)(T T nil)))
        ))
        ((equal peca 't) (list  (make-array (list 3 2) :initial-contents '((nil T)(T T)(nil T)))
                                (make-array (list 2 3) :initial-contents '((nil T nil)(T T T)))
                                (make-array (list 3 2) :initial-contents '((T nil)(T T)(T nil)))
                                (make-array (list 2 3) :initial-contents '((T T T)(nil T nil)))
        ))
  ))
