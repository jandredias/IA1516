;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TABULEIRO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; cria-tabuleiro: {} --> tabuleiro
;;; Este construtor não recebe qualquer argumento, e devolve um novo tabuleiro
;;; vazio. A representacão escolhida foi um array bidimensional pois permite
;;; aceder a qualquer posicão do tabuleiro em tempo constante.
(defun cria-tabuleiro ()
  (make-array '(20 10) :element-type 'boolean))

;;; copia-tabuleiro: tabuleiro --> tabuleiro
;;; Este construtor recebe um tabuleiro, e devolve um novo tabuleiro com o mesmo
;;; conteudo do tabuleiro recebido. O tabuleiro devolvido deve ser um objecto
;;; computacional diferente e devera garantir que qualquer alteracão feita ao
;;; tabuleiro original não deve ser repercutida no novo tabuleiro e vice-versa.
(defun copia-tabuleiro (tabuleiro)
  (let ((novoTabuleiro (cria-tabuleiro)))
  ;copia os valores maximos das linhas de cada coluna e depois devolve o
  ;tabuleiro copiado
  (dotimes (coluna 10 (dotimes (l 18 novoTabuleiro)
                        (dotimes (c 10)
                          (cond ((tabuleiro-preenchido-p tabuleiro l c)
                                    (tabuleiro-preenche! novoTabuleiro l c))))))
  (setf (aref novoTabuleiro 18 coluna) (aref tabuleiro 18 coluna))
  (setf (aref novoTabuleiro 19 coluna) (aref tabuleiro 19 coluna)))

))

(defun tabuleiro-preenchido-p (tabuleiro linha coluna)
  (aref tabuleiro linha coluna)
)

(defun tabuleiro-altura-coluna (tabuleiro coluna)
  ;if cache value if valid then return cached value
  (if (aref tabuleiro 19 coluna)
    (aref tabuleiro 18 coluna)

  ;otherwise it will compute the value, cache it and then return it
    (let ((linha 17))
    (setf (aref tabuleiro 19 coluna) T)
    (setf (aref tabuleiro 18 coluna)
      (loop
        (if (tabuleiro-preenchido-p tabuleiro linha coluna) (return (1+ linha))
            (if (equal linha 0) (return 0)
                                (decf linha))))))))

(defun tabuleiro-preenche! (tab linha coluna)
  (if (and (>= linha 0) (<= linha 17) (>= coluna 0) (<= coluna 9))
      (progn (setf (aref tab linha coluna) T)
             (setf (aref tab 19 coluna) NIL))))


(defun tabuleiro-linha-completa-p (tab linha)
  (let ((array_linha (array-slice tab linha)))
    (not (position NIL array_linha))))

(defun array-slice (arr line)
  (make-array (array-dimension arr 1)
    :displaced-to arr
      :displaced-index-offset (* line (array-dimension arr 1))))

(defun tabuleiro-topo-preenchido-p (tab)
  (let ((array_linha (array-slice tab 17)))
  (cond ((position T array_linha) T) (T NIL))))

(defun tabuleiros-iguais-p (tab1 tab2)
  (let ((RESULT T))
  (dotimes (l 18 RESULT)
    (dotimes (c 10)
      (cond
        ((not (equal (tabuleiro-preenchido-p tab1 l c)
                     (tabuleiro-preenchido-p tab2 l c)))
         (setf RESULT NIL)))))))

;;; tabuleiro-remove-linha!: tabuleiro x inteiro --> {}
;;; Este modificador recebe um tabuleiro, um inteiro correspondente ao numero de
;;; linha, e altera o tabuleiro recebido removendo essa linha do tabuleiro, e
;;; fazendo com que as linhas por cima da linha removida descam uma linha.
;;; As linhas que estão por baixo da linha removida não podem ser alteradas.
;;; O valor devolvido por desta funcão não esta definido.
(defun tabuleiro-remove-linha! (tab linha)
  (let ((upperl linha))
  (loop for l from linha below 17
      do (
          progn
          (incf upperl)
          (dotimes (c 10)
            (setf (aref tab l c) (aref tab upperl c)))))
  ;; Acho que ela ja esta vazia anyway...
  ;; porque se tivermos preenchido ai perdemos o jogo
  ;; A linha de cima (17) tem de passar a ser vazia caso nao seja
  (dotimes (c 10)
    (setf (aref tab 17 c) NIL)) 
  (dotimes (c 10)
    (setf (aref tab 19 c) NIL))
))


;; FIXME
(defun tabuleiro->array (tabuleiro)
  (let ((arrayVar (make-array '(18 10) :element-type 'boolean)))
  (dotimes (l 18 arrayVar)
    (dotimes (c 10)
      (cond ((tabuleiro-preenchido-p tabuleiro l c)
             (setf (aref arrayVar l c) T)))))))

(defun array->tabuleiro (array)
  (copia-tabuleiro array))
