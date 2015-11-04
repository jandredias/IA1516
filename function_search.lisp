;;;;;;;;;;;;;;;;;;;;;;;;;; Funçoes do problema de procura 2.2.1 ;;;;;;;;;;;;;;;;
;;PECAS: I J L O S Z T
;; Devolve logico
(defun solucao (estado)
  (and (not (tabuleiro-topo-preenchido-p estado-tabuleiro))
       (null estado-pecas-por-colocar)))

;; Devolve lista accoes
(defun accoes (estado)
  )

;; Devolve estado
(defun resultado (estado_in accao)
  (let (( coluna (accao-coluna accao))
        ( coluna_aux (accao-coluna accao))
        ( peca   (accao-peca accao))
        )
  (setf dimensoes_peca (array-dimensions peca))
  (setf max (list 0 coluna))
  (setf lst_contorno_peca '())
  (print peca)
  (loop for j from (1- (second dimensoes_peca)) downto 0 do
    (dotimes (n (first dimensoes_peca))
        (when (aref peca n j)(progn (push n lst_contorno_peca) (return T)))
    )
  )
  lst_contorno_peca

  (setf tabuleiro_criado (copia-tabuleiro (estado-tabuleiro estado_in)))

  (print 'max)
  (print max)
  (dolist (elem lst_contorno_peca max)
      (print 'ELEM)
      (print ELEM)
      (print 'coluna_aux)
      (print coluna_aux)
      (setf valor_calc (- (tabuleiro-altura-coluna tabuleiro_criado coluna_aux) elem))
      (print 'valor_calc)
      (print valor_calc)
      (cond ((< (first max) valor_calc) (setf max (list valor_calc coluna_aux))))
      (print 'max)
      (print max)
      (incf coluna_aux)
  )
  (setf difference (- (second max) coluna))
  (print 'here)
  (print difference)
  (setf base_writing_y (- (first max) (nth difference lst_contorno_peca)))
  (print 'here21321)
  (setf base_writing_x coluna)
  (dotimes (i (second dimensoes_peca))
    (setf writing_x (+ base_writing_x i))
    (dotimes (n (first dimensoes_peca))
      (setf writing_y (+ base_writing_y n))
      (print 'i)
      (print i)
      (print 'n)
      (print n)
      (print 'wrt_x)
      (print writing_x)
      (print 'wrt_y)
      (print writing_y)

      (cond ((aref peca n i) (progn (print 'coords)(print (list writing_x writing_y))(tabuleiro-preenche! tabuleiro_criado writing_x writing_y)))
      )
    )
  )



  (setf new-points 50)

  (make-estado :pontos new-points
               :pecas-por-colocar (rest (estado-pecas-por-colocar estado_in))
               :pecas-colocadas (push (first (estado-pecas-por-colocar estado_in))(estado-pecas-colocadas estado_in))
               :tabuleiro tabuleiro_criado)
  tabuleiro_criado))

(setf estad (make-estado :pontos 100 :pecas-por-colocar '('i 'j 'l) :pecas-colocadas '('z) :tabuleiro (cria-tabuleiro)))
(setf accao (cria-accao 5 peca-j2))
(resultado estad accao)


;; Devolve inteiro
(defun qualidade (estado_in)
  (- (estado-pontos estado_in))
)

;; Devolve inteiro
(defun custo-opurtonidade (estado))


;; Devolve uma lista com as possiveis pecas rodadas
(defun pecas_possiveis (peca)
  (cond ((equal peca 'i) '(peca-i0 peca-i1))
        ((equal peca 'l) '(peca-l0 peca-l1 peca-l2 peca-l3))
        ((equal peca 'j) '(peca-j0 peca-j1 peca-j2 peca-j3))
        ((equal peca 'o) '(peca-o0))
        ((equal peca 's) '(peca-s0 peca-s1))
        ((equal peca 'z) '(peca-z0 peca-z1))
        ((equal peca 't) '(peca-t0 peca-t1 peca-t2 peca-t3))
  ))
