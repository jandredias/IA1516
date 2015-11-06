;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TABULEIRO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun cria-tabuleiro ()
  (make-array '(18 10) :element-type 'boolean)
)

(defun copia-tabuleiro (tab_velho)
  (let ((tab_novo (cria-tabuleiro)))
  (dotimes (l 18 tab_novo)
    (dotimes (c 10)
      (cond ((tabuleiro-preenchido-p tab_velho l c)
                (tabuleiro-preenche! tab_novo l c)))))))

(defun tabuleiro-preenchido-p (tab linha coluna)
  (aref tab linha coluna)
)

(defun tabuleiro-altura-coluna (tab col)
  (let ((linha 17))
  (loop
    (if (tabuleiro-preenchido-p tab linha col) (return (1+ linha))
        (if (equal linha 0) (return 0)
                            (decf linha))))))

(defun tabuleiro-preenche! (tab linha coluna)
  (cond ((and (>= linha 0) (<= linha 17) (>= coluna 0) (<= coluna 9))
            (setf (aref tab linha coluna) T))
        (t t)))


(defun tabuleiro-linha-completa-p (tab linha)
  (let ((array_linha (array-slice tab linha)))
  (not (position NIL array_linha)))
)

(defun array-slice (arr line)
    (make-array (array-dimension arr 1)
      :displaced-to arr
       :displaced-index-offset (* line (array-dimension arr 1))
    )
 )
(defun tabuleiro-topo-preenchido-p (tab)
  (let ((array_linha (array-slice tab 17)))
  (cond ((position T array_linha) T)
        (T NIL)
  ))
)

(defun tabuleiros-iguais-p (tab1 tab2)
  (let ((RESULT T))
  (dotimes (l 18 RESULT)
    (dotimes (c 10)
      (cond
        ((not (equal (tabuleiro-preenchido-p tab1 l c) (tabuleiro-preenchido-p tab2 l c)))
          (setf RESULT NIL)
        ))))))



(defun tabuleiro-remove-linha! (tab linha)
  (let ((upperl linha))
  (loop for l from linha below 17
      do (
          progn
          (incf upperl)
          (dotimes (c 10)
            (setf (aref tab l c) (aref tab upperl c)))))
  ;; Acho que ela ja esta vazia anyway... porque se tivermos preenchido ai perdemos o jogo
  ;; A linha de cima (17) tem de passar a ser vazia caso nao seja
  (dotimes (c 10)
    (setf (aref tab 17 c) NIL))))

(defun tabuleiro->array (tab)
  (copia-tabuleiro tab))
(defun array->tabuleiro (array)
  (copia-tabuleiro array))
