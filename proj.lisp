;;;;;;;;; ACCAO

(defun cria-accao (col peca)
  (cons col peca))

(defun accao-coluna (accao)
  (car accao))

(defun accao-peca (accao)
  (cdr accao))

;;;;;;;;; TABULEIRO

(defun cria-tabuleiro ()
  (make-array '(18 10) :element-type 'boolean))

;(defun copia-tabuleiro (tabuleiro)
;  (let ((novoTab (cria-tabuleiro)))
;  )
