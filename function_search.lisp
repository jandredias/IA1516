;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;; Funcoes do problema de procura 2.2.1 ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;PECAS: I J L O S Z T

;;; solucao: estado --> logico
;;; Esta funcao recebe um estado, e devolve o valor logico verdade se o estado
;;; recebido corresponder a uma solucao, e falso contrario. Um estado do jogo
;;; Tetris e considerado solucao se o topo do tabuleiro nao estiver preenchido
;;; e se ja nao existem pecas por colocar, todas as pecas foram colocadas com
;;; sucesso (independentemente de terem ou nao sido obtidos pontos).
(defun solucao (estado_in)
  (and (not (tabuleiro-topo-preenchido-p (estado-tabuleiro estado_in)))
       (null (estado-pecas-por-colocar estado_in))))

;;; accoes: estado --> lista de accoes
;;; A funcao recebe um estado e devolve uma lista de accoes correspondendo a
;;; todas as accoes validas que podem ser feitas com a proxima peca a ser
;;; colocada. Uma accao e considerada valida mesmo que faca o jogador perder o
;;; jogo (i.e. preencher a linha do topo). Uma accao e invalida se nao for
;;; fisicamente possivel dentro dos limites laterais do jogo.
;;; A ordem com que sao devolvidas as accoes na lista e muito importante. 
;;; A frente da lista devem estar obrigatoriamente as accoes correspondentes a
;;; orientacao inicial da peca, percorrendo todas as colunas possiveis da
;;; esquerda para a direita. Depois e escolhida uma nova orientacao, rodando a
;;; peca 90o no sentido horario, e volta-se a gerar para todas as colunas
;;; possiveis da esquerda para a direita. No entanto, se ao rodar uma peca
;;; obter uma configuracao geometrica ja explorada anteriormente (como por
;;; exemplo no caso da peca O em que todas as rotacoes correspondem a mesma
;;; configuracao) nao devem ser geradas novamente as accoes.
(defun accoes (estado-in)
  (let ((lista (list)))
    (if (estado-final-p estado-in) NIL (progn
    (dolist (el (pecas_possiveis (first (estado-pecas-por-colocar estado-in))))
      (loop for k from (- 10 (array-dimension el 1)) downto 0
      do (push (cria-accao k el) lista)))
    lista))))

;;; resultado: estado x accao --> estado
;;; Esta funcao recebe um estado e uma accao, e devolve um novo estado que
;;; resulta de aplicar a accao recebida no estado original. Atencao, o estado
;;; original nao pode ser alterado em situacao alguma. Esta funcao deve
;;; actualizar as listas de pecas, colocar a peca especificada pela accao na
;;; posicao correcta do tabuleiro. Depois de colocada a peca, e verificado se o
;;; topo do tabuleiro esta preenchido. Se estiver, nao se removem linhas e
;;; devolve-se o estado. Se nao estiver, removem-se as linhas e calculam-se
;;; os pontos obtidos.
(defun resultado (estado-in accao)
  (let ((estado (copia-estado estado-in))
        (peca   (accao-peca accao))
        (contorno '())
        (linhaBase 0)
        (colunaAux (accao-coluna accao))
        (valorCalc 0)
        (linhaAux)
        (pontos)
        (linhasRemovidas)
        (linhasPontos)
       )

    ;;Cria lista com alturas da peca
    (loop for j from (1- (second (array-dimensions peca))) downto 0 do
      (dotimes (n (first (array-dimensions peca)))
               (when (aref peca n j)
                     (progn (push n contorno) (return T)))))

    ;; contorno e a lista que contem a altura de cada uma das colunas da peca
    ;; por exemplo, na peca L rodada 90graus a direita seria:
    ;;
    ;;   OOO
    ;;   O    => (0, 1, 1)
    
    ;;Calcular posicao de escrita
    (dolist (el contorno)
            (setf valorCalc
              (- (tabuleiro-altura-coluna (estado-tabuleiro estado-in)
                                          colunaAux) el))
            (cond ((< linhaBase valorCalc) (setf linhaBase valorCalc)))
            (incf colunaAux))

    ;;Colocar peca no tabuleiro
    (dotimes (y (first (array-dimensions peca)))
      (setf linhaAux (+ linhaBase y))
      (dotimes (x (second (array-dimensions peca)))
        (setf colunaAux (+ (accao-coluna accao) x))
        (cond ((aref peca y x) (tabuleiro-preenche! (estado-tabuleiro estado)
                                                    linhaAux
                                                    colunaAux)))))
    
    (setf pontos (estado-pontos estado-in))
    (if (and (< linhaBase 18) 
             (not (tabuleiro-topo-preenchido-p (estado-tabuleiro estado))))
        (progn
          (setf linhasRemovidas 0)
          (setf linhasPontos 0)
          (loop for i from linhaBase to linhaAux do
            (progn
              (if (tabuleiro-linha-completa-p (estado-tabuleiro estado)
                                              (- i linhasRemovidas))
                  (progn
                    (tabuleiro-remove-linha! (estado-tabuleiro estado)
                                             (- i linhasRemovidas))
                    (incf linhasRemovidas)))))
        (cond ((= linhasRemovidas 0) T)
              ((= linhasRemovidas 1) (setf pontos (+ pontos 100)))
              ((= linhasRemovidas 2) (setf pontos (+ pontos 300)))
              ((= linhasRemovidas 3) (setf pontos (+ pontos 500)))
              ((= linhasRemovidas 4) (setf pontos (+ pontos 800))))))
    (setf (estado-pontos estado) pontos)
    (setf (estado-pecas-por-colocar estado)
          (rest (estado-pecas-por-colocar estado-in)))
    (setf (estado-pecas-colocadas estado)
          (push (first (estado-pecas-por-colocar estado-in))
                (estado-pecas-colocadas estado)))
    estado))

;;; qualidade: estado -> inteiro
;;; Os algoritmos de procura informada estao concebidos para tentar minimizar
;;; o custo de caminho. No entanto, se quisermos maximizar os pontos obtidos,
;;; podemos olhar para isto como um problema de maximizacao de qualidade. Para
;;; podermos usar a qualidade com os algoritmos de procura melhor primeiro, uma
;;; solucao simples e convertermos a qualidade num valor negativo de custo.
;;; Assim sendo, um estado com mais pontos ira ter um valor menor (negativo) e
;;; tera prioridade para o mecanismo de escolha do proximo no a ser expandido.
;;; Portanto, a funcao qualidade recebe um estado e retorna um valor de
;;; qualidade que corresponde ao valor negativo dos pontos ganhos ate ao momento.
(defun qualidade (estado_in)
  (- (estado-pontos estado_in)))

;;; custo-oportunidade: estado -> inteiro
;;; Uma representacao alternativa para um problema de maximizacao de qualidade,
;;; e considerar que por cada accao podemos potencialmente ganhar um determinado
;;; valor, e que o custo e dado pelo facto de nao conseguirmos ter aproveitado
;;; ao maximo a oportunidade. Assim sendo o custo de oportunidade pode ser
;;; calculado como a diferenca entre o maximo possivel e o efetivamente
;;; conseguido. Portanto esta funcao, dado um estado, devolve o custo de
;;; oportunidade de todas as accoes realizadas ate ao momento, assumindo que e
;;; sempre possivel fazer o maximo de pontos por cada peca colocada.
;;; Ao usarmos esta funcao como custo, os algoritmos de procura irao tentar
;;; minimizar o custo de oportunidade.
(defun custo-oportunidade (estado_in)
  (let ((lista_colocadas (estado-pecas-colocadas estado_in))
        (valor_oportunidade 0)
        (valor_real (estado-pontos estado_in)))

      ;;Calcular valor_oportunidade
      (dolist (elem lista_colocadas)
        (cond ((eq elem 'I) (incf valor_oportunidade 800))
              ((eq elem 'J) (incf valor_oportunidade 500))
              ((eq elem 'L) (incf valor_oportunidade 500))
              ((eq elem 'S) (incf valor_oportunidade 300))
              ((eq elem 'Z) (incf valor_oportunidade 300))
              ((eq elem 'T) (incf valor_oportunidade 300))
              ((eq elem 'O) (incf valor_oportunidade 300))))
      (- valor_oportunidade valor_real)))


;;; pecas_possiveis: peca --> lista de pecas
;;; Esta funcao recebe uma peca, e devolve uma lista de pecas que contem as
;;; representacoes possiveis dessa mesma peca rodada. 
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
