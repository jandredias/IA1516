;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Grupo 66 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 75741 João Figueiredo
;;; 75966 Frederico Moura
;;; 78865 Miguel Amaral
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TABULEIRO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun cria-tabuleiro ()
  (make-array '(18 10) :element-type 'boolean)
)

(defun tabuleiro-preenchido-p (tab linha coluna)
  (aref tab linha coluna)
)

(defun tabuleiro-preenche! (tab linha coluna)
  (cond
    ( ;; If Condition
      (and (>= linha 0) (<= linha 17) (>= coluna 0) (<= coluna 9) )
        ;; Then
        (setf (aref tab linha coluna) T)
    )
  )
)

(defun tabuleiro-altura-coluna (tab coluna)
  (setf linha 0)
  (loop
    (when (not (tabuleiro-preenchido-p tab linha coluna))
      (decf linha)
      (cond
        ((= linha -1)
          (setf linha 0)
        )
      )
      (return linha)
    )
    (incf linha)
    (when (= linha 18) (return 17))
  )

)
(defun tabuleiro-linha-completa-p (tab linha)
  (setf array_linha (array-slice tab linha))
  (not (position NIL array_linha))
)

(defun array-slice (arr line)
    (make-array (array-dimension arr 1)
      :displaced-to arr
       :displaced-index-offset (* line (array-dimension arr 1))
    )
 )
(defun tabuleiro-topo-preenchido-p (tab)
  (setf array_linha (array-slice tab 17))
  (cond ((position T array_linha) T)
        (T NIL)
  )
)

(defun tabuleiros-iguais-p (tab1 tab2)
  (setf RESULT T)
  (dotimes (l 18)
    (dotimes (c 10)
      (cond
        ((not (equal (tabuleiro-preenchido-p tab1 l c) (tabuleiro-preenchido-p tab2 l c)))
          (setf RESULT NIL)
        )
      )
    )
  )
  RESULT
)

(defun copia-tabuleiro (tab_velho)
  (setf tab_novo (cria-tabuleiro))
  (dotimes (l 18)
    (dotimes (c 10)
      (cond ((tabuleiro-preenchido-p tab_velho l c)
                (tabuleiro-preenche! tab_novo l c)
            )
      )
    )
  )
  tab_novo
)

(defun tabuleiro-remove-linha! (tab linha)
  (setf upperl linha)
  (loop for l from linha below 17
      do (
          progn
          (incf upperl)
          (dotimes (c 10)
            (setf (aref tab l c) (aref tab upperl c))
          )
      )
  )
  ;; A linha de cima (17) tem de passar a ser vazia caso nao seja
  (dotimes (c 10)
    (setf (aref tab 17 c) NIL)
  )
)

(defun tabuleiro->array (tab)
  (copia-tabuleiro tab)
)
(defun array->tabuleiro (array)
  (copia-tabuleiro array)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ACCAO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun cria-accao (col_e peca)
  (list col_e peca)
)

(defun accao-coluna (accao)
  (nth 0 accao)
)

(defun accao-peca (accao)
  (nth 1 accao)
)

;;;;;;;;;;;;;;;;;;;;;;;;;; Funçoes do problema de procura 2.2.1 ;;;;;;;;;;;;;;;;

;; Devolve logico
(defun solucao (estado))

;; Devolve lista accoes
(defun accoes (estado))

;; Devolve estado
(defun resultado (estado accao))

;; Devolve inteiro
(defun qualidade (estado))

;; Devolve inteiro
(defun custo-opurtonidade (estado))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ESTADO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defstruct ESTADO pontos pecas-por-colocar pecas-colocadas tabuleiro)

(defun copia-estado (input_estado)
  (make-estado :pontos               (estado-pontos input_estado)
               :pecas-por-colocar    (estado-pecas-por-colocar input_estado)
               :pecas-colocadas      (estado-pecas-colocadas input_estado)
               :tabuleiro            (estado-tabuleiro input_estado)
  )
)
(defun estados-iguais-p (estado1 estado2)
    (and 
	 (equal estado1-pontos estado2-pontos)
	 (equal estado1-pecas-por-colocar estado2-pecas-por-colocar)
	 (equal estado1-pecas-colocadas estado2-pecas-colocadas)
	 (equal estado1-tabuleiro estado2-tabuleiro)
    )	 
)

(defun estado-final-p (estado)
  (or 
    (tabuleiro-topo-preenchido-p estado-tabuleiro)
    (null estado-pecas-por-colocar)
  ) 
)

;(make-estado :pontos 100 :pecas-por-colocar 20 :pecas-colocadas 5 :tabuleiro (cria-tabuleiro))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PROBLEMA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defstruct PROBLEMA estado-inicial solucao accoes resultado custo-caminho)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DEBUG ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setf tab1 (cria-tabuleiro))

;; Coluna 1 Preenchida
(tabuleiro-preenche! tab1 0 0)
(tabuleiro-preenche! tab1 1 0)
(tabuleiro-preenche! tab1 2 0)
(tabuleiro-preenche! tab1 3 0)
(tabuleiro-preenche! tab1 4 0)
(tabuleiro-preenche! tab1 5 0)
(tabuleiro-preenche! tab1 6 0)
(tabuleiro-preenche! tab1 7 0)
(tabuleiro-preenche! tab1 8 0)
(tabuleiro-preenche! tab1 9 0)
(tabuleiro-preenche! tab1 10 0)
(tabuleiro-preenche! tab1 11 0)
(tabuleiro-preenche! tab1 12 0)
(tabuleiro-preenche! tab1 13 0)
(tabuleiro-preenche! tab1 14 0)
(tabuleiro-preenche! tab1 15 0)
(tabuleiro-preenche! tab1 16 0)
(tabuleiro-preenche! tab1 17 0)
(tabuleiro-preenche! tab1 17 1)
(tabuleiro-preenche! tab1 17 2)
(tabuleiro-preenche! tab1 17 3)
(tabuleiro-preenche! tab1 17 4)

(tabuleiro-preenche! tab1 0 1)
(tabuleiro-preenche! tab1 0 2)
(tabuleiro-preenche! tab1 0 3)
(tabuleiro-preenche! tab1 0 4)
(tabuleiro-preenche! tab1 0 5)
(tabuleiro-preenche! tab1 0 6)
(tabuleiro-preenche! tab1 0 7)
(tabuleiro-preenche! tab1 0 8)




(tabuleiro-preenche! tab1 1 1)
(tabuleiro-preenche! tab1 2 1)
(tabuleiro-preenche! tab1 3 1)
(tabuleiro-preenche! tab1 3 2)

(tabuleiro-preenche! tab1 1 2)
(tabuleiro-preenche! tab1 1 3)
(tabuleiro-preenche! tab1 2 2)
(tabuleiro-preenche! tab1 4 1)
(tabuleiro-preenche! tab1 4 2)
tab1

(tabuleiro-altura-coluna tab1 0)
(tabuleiro-altura-coluna tab1 1)
(tabuleiro-altura-coluna tab1 2)
(tabuleiro-altura-coluna tab1 9)
(setf array (array-slice tab1 0))
(tabuleiro-linha-completa-p tab1 0)
(tabuleiro-topo-preenchido-p tab1)
;tabuleiros-iguais tab1 tab1)
(setf tab2 (copia-tabuleiro tab1))
