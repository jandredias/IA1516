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
