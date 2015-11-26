;;; Teste 14 E2
;;; procura profundidade primeiro num tabuleiro com algumas pecas
;;deve retornar IGNORE
;(ignore-value (setf t1 (cria-tabuleiro)))
;(ignore-value (dotimes (coluna 9) (tabuleiro-preenche! t1 0 (+ coluna 1))(tabuleiro-preenche! t1 1 (+ coluna 1))(tabuleiro-preenche! t1 2 (+ coluna 1))))
;;deve retornar uma lista de accoes (ver ficheiro output)
;(procura-pp (make-problema :estado-inicial (make-estado :pontos 0 :tabuleiro t1 :pecas-colocadas () :pecas-por-colocar '(o o o o o l l t t j j i i)) :solucao #'solucao :accoes #'accoes :resultado #'resultado :custo-caminho #'(lambda (x) 0)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;; Testing heuristicas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setf tab (cria-tabuleiro))
(setf estado_in (make-estado :pontos 0 :tabuleiro tab))
(setf teste 0)

(defun testa-heuristicas (estado_in)
  (desenha-estado estado_in)

  (print 'aggregate-height)
  (print (aggregate-height estado_in))

  (print 'complete-lines)
  (print (complete-lines estado_in))

  (print 'holes)
  (print (holes estado_in))

  (print 'bumpiness)
  (print (bumpiness estado_in))
  (read-char)
)


(testa-heuristicas estado_in)
(tabuleiro-preenche! tab 3 0)
(tabuleiro-preenche! tab 1 0)
(tabuleiro-preenche! tab 2 1)
(tabuleiro-preenche! tab 1 1)
(tabuleiro-preenche! tab 0 1)
(tabuleiro-preenche! tab 1 2)
(tabuleiro-preenche! tab 0 2)
(tabuleiro-preenche! tab 0 3)
(tabuleiro-preenche! tab 0 4)
(tabuleiro-preenche! tab 0 5)
(tabuleiro-preenche! tab 0 6)
(tabuleiro-preenche! tab 0 7)
(tabuleiro-preenche! tab 0 8)
(tabuleiro-preenche! tab 0 9)
(setf (estado-pontos estado_in) 1000)
(testa-heuristicas estado_in)


(print (incf teste))
;aggregate-height (estado-in)
;complete-lines (estado-in)
;holes (estado-in)
;bumpiness (estado-in)
(quit)
