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
(defun accoes (estado-in)
  (let ((lista (list)))
    (if (estado-final-p estado-in) NIL (progn
    (dolist (el (pecas_possiveis (first (estado-pecas-por-colocar estado-in))))
      (loop for k from (- 10 (array-dimension el 1)) downto 0
      do (push (cria-accao k el) lista)))
    lista))))

;;; resultado: estado x accao --> estado
;;; Esta funcão recebe um estado e uma accão, e devolve um novo estado que
;;; resulta de aplicar a accão recebida no estado original. Atencão, o estado
;;; original não pode ser alterado em situacão alguma. Esta funcão deve
;;; actualizar as listas de pecas, colocar a peca especificada pela accão na
;;; posicão correcta do tabuleiro. Depois de colocada a peca, e verificado se o
;;; topo do tabuleiro esta preenchido. Se estiver, não se removem linhas e
;;; devolve-se o estado. Se não estiver, removem-se as linhas e calculam-se
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
              (-(tabuleiro-altura-coluna (estado-tabuleiro estado-in) colunaAux) el))
            (cond ((< linhaBase valorCalc) (setf linhaBase valorCalc)))
            (incf colunaAux))

    ;;Colocar peca no tabuleiro
    (dotimes (y (first (array-dimensions peca)))
      (setf linhaAux (+ linhaBase y))
      (dotimes (x (second (array-dimensions peca)))
        (setf colunaAux (+ (accao-coluna accao) x))
        (cond ((aref peca y x) (tabuleiro-preenche! (estado-tabuleiro estado) linhaAux colunaAux)))))
    
    (setf pontos (estado-pontos estado-in))
    (if (and (< linhaBase 18) (not (tabuleiro-topo-preenchido-p (estado-tabuleiro estado))))
        (progn
          (setf linhasRemovidas 0)
          (setf linhasPontos 0)
          (loop for i from linhaBase to linhaAux do
            (progn
              (if (tabuleiro-linha-completa-p (estado-tabuleiro estado) (- i linhasRemovidas))
                  (progn
                    (tabuleiro-remove-linha! (estado-tabuleiro estado) (- i linhasRemovidas))
                    (incf linhasRemovidas)))))
        (cond ((= linhasRemovidas 0) T)
              ((= linhasRemovidas 1) (setf pontos (+ pontos 100)))
              ((= linhasRemovidas 2) (setf pontos (+ pontos 300)))
              ((= linhasRemovidas 3) (setf pontos (+ pontos 500)))
              ((= linhasRemovidas 4) (setf pontos (+ pontos 800))))))
    (setf (estado-pontos estado) pontos)
    (setf (estado-pecas-por-colocar estado) (rest (estado-pecas-por-colocar estado-in)))
    (setf (estado-pecas-colocadas estado) (push (first (estado-pecas-por-colocar estado-in)) (estado-pecas-colocadas estado)))
    estado))

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
