;;; Teste 14 E2
;;; procura profundidade primeiro num tabuleiro com algumas pecas
;;deve retornar IGNORE
(ignore-value (setf t1 (cria-tabuleiro)))
(ignore-value (dotimes (coluna 9) (tabuleiro-preenche! t1 0 (+ coluna 1))(tabuleiro-preenche! t1 1 (+ coluna 1))(tabuleiro-preenche! t1 2 (+ coluna 1))))
;;deve retornar uma lista de accoes (ver ficheiro output)
(procura-pp (make-problema :estado-inicial (make-estado :pontos 0 :tabuleiro t1 :pecas-colocadas () :pecas-por-colocar '(o o o o o l l t t j j i i)) :solucao #'solucao :accoes #'accoes :resultado #'resultado :custo-caminho #'(lambda (x) 0)))
