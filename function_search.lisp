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
(defun resultado (estado accao))

;; Devolve inteiro
(defun qualidade (estado_in)
  (- (estado-pontos estado_in))
)

;; Devolve inteiro
(defun custo-opurtonidade (estado))


;; Devolve uma lista com as pecas rodadas
(defun roda (peca)
  (cond ((equal peca 'i) '(peca-i0 peca-i1))
        ((equal peca 'l) '(peca-l0 peca-l1 peca-l2 peca-l3))
        ((equal peca 'j) '(peca-j0 peca-j1 peca-j2 peca-j3))
        ((equal peca 'o) '(peca-o0))
        ((equal peca 's) '(peca-s0 peca-s1))
        ((equal peca 'z) '(peca-z0 peca-z1))
        ((equal peca 't) '(peca-t0 peca-t1 peca-t2 peca-t3))
  ))
