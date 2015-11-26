;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ESTADO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; O tipo estado representa o estado de um jogo de Tetris. Este tipo devera ser
;;; implementado obrigatoriamente como uma estrutura em Common Lisp com os
;;; seguintes campos:
;;; -> pontos – o numero de pontos conseguidos ate ao momento no jogo;
;;; -> pecas-por-colocar – uma lista com as pecas que ainda estao por colocar,
;;;    pela ordem de colocacao. As pecas nesta lista sao representadas pelo
;;;    simbolo correspondente a letra da peca, i.e. i,j,l,o,s,z,t;
;;; -> pecas-colocadas – uma lista com as pecas ja colocadas no tabuleiro
;;;    (representadas tambem pelo simbolo). Esta lista deve encontrar-se
;;;    ordenada da peca mais recente para a mais antiga;
;;; -> tabuleiro – o tabuleiro com as posicões actualmente preenchidas do jogo.
(defstruct ESTADO pontos pecas-por-colocar pecas-colocadas tabuleiro)

;;; copia-estado: estado -> estado
;;; Este construtor recebe um estado e devolve um novo estado cujo conteudo deve
;;; ser copiado a partir do estado original. O estado devolvido devera garantir 
;;; que qualquer alteracao feita ao estado original nao deve ser repercutida no 
;;; novo estado e vice-versa.
(defun copia-estado (input_estado)
  (make-estado :pontos            (estado-pontos input_estado)
               :pecas-por-colocar (copy-list
                                    (estado-pecas-por-colocar input_estado))
               :pecas-colocadas   (copy-list
                                    (estado-pecas-colocadas input_estado))
               :tabuleiro         (copia-tabuleiro
                                    (estado-tabuleiro input_estado))))

;;; estados-iguais-p: estado x estado -> logico
;;; Este teste recebe dois estados, e devolve o valor logico verdade se os dois
;;; estados forem iguais (i.e. tiverem o mesmo conteudo) e falso caso contrario.
(defun estados-iguais-p (estado1 estado2)
    (and
  	 (equal (estado-pontos estado1)
                (estado-pontos estado2))
  	 (equal (estado-pecas-por-colocar estado1)
                (estado-pecas-por-colocar estado2))
  	 (equal (estado-pecas-colocadas estado1)
                (estado-pecas-colocadas estado2))
  	 (tabuleiros-iguais-p (estado-tabuleiro estado1)
                              (estado-tabuleiro estado2))))


;;; estado-final-p: estado -> logico
;;; Este reconhecedor recebe um estado e devolve o valor logico verdade se
;;; corresponder a um estado final onde o jogador ja nao possa fazer mais
;;; jogadas e falso caso contrario. Um estado e considerado final se o tabuleiro
;;; tiver atingido o topo ou se ja nao existem pecas por colocar.
(defun estado-final-p (estado)
  (or
    (null (estado-pecas-por-colocar estado))
    (tabuleiro-topo-preenchido-p (estado-tabuleiro estado))))

