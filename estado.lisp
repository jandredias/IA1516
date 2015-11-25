;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ESTADO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defstruct ESTADO pontos pecas-por-colocar pecas-colocadas tabuleiro)

(defun copia-estado (input_estado)
  (make-estado :pontos               (estado-pontos input_estado)
               :pecas-por-colocar    (copy-list
                                       (estado-pecas-por-colocar input_estado))
               :pecas-colocadas      (copy-list
                                       (estado-pecas-colocadas input_estado))
               :tabuleiro            (copia-tabuleiro
                                       (estado-tabuleiro input_estado))
  )
)
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

(defun estado-final-p (estado)
  (or
    (null (estado-pecas-por-colocar estado))
    (tabuleiro-topo-preenchido-p (estado-tabuleiro estado))))
