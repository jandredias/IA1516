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
  	 (equal estado1-tabuleiro estado2-tabuleiro)))

(defun estado-final-p (estado)
  (or
    (null (estado-pecas-por-colocar estado))
    (tabuleiro-topo-preenchido-p (estado-tabuleiro estado))))
