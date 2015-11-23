;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PROCURAS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; descricao
;;;   Resolve um problema que a estrutura recebida represente
;;;   O problema e' resolvido usando uma procura em profundidade primeiro em a'rvore
;;; @param struct problema
;;; @return lista de acoes
(defun procura-pp (problema_in)
  (let ((estado      (problema-estado-inicial problema_in))
        (fun_solucao (problema-solucao problema_in))
        (fun_accoes  (problema-accoes problema_in))
        (fun_resultado   (problema-resultado problema_in)))
  #| Do work |#
  (if (not (funcall fun_solucao estado))
      #|(implement )|#
  )
  )
)

#|(defstruct PROBLEMA estado-inicial solucao accoes resultado custo-caminho)|#
 estado-inicial – contem o estado inicial do problema de procura;
 solucao – função que recebe um estado e devolve T se o estado for uma solução para o
problema de procura, e nil caso contrário;
 accoes – função que recebe um estado e devolve uma lista com todas as acções que são
possíveis fazer nesse estado;
 resultado – função que dado um estado e uma acção devolve o estado sucessor que
resulta de executar a acção recebida no estado recebido;
 custo-caminho – função que dado um estado devolve o custo do caminho desde o
estado inicial até esse estado


(defun procura-A* (problema heuristica)
)


(defun procura-best (tabuleiro pecas)
)
