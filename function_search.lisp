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
(defun resultado (estado accao)
  (setf coluna (accao-coluna accao))
  (setf peca   (accao-peca accao))
  (setf peca_array_base (array-slice peca 0))
  (array-dimension peca_array_base 0)
;(setf estad (make-estado :pontos 100 :pecas-por-colocar '('i 'j 'l) :pecas-colocadas 5 :tabuleiro (cria-tabuleiro)))
;(setf accao (cria-accao 5 peca-i0))
;(resultado estad accao)
)


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
