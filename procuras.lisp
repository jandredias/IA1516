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
        (function_solucao (problema-solucao problema_in))
        (function_accoes  (problema-accoes problema_in))
        (function_resultado   (problema-resultado problema_in))
        (proximoProblema NIL)
        (proximoEstado NIL)
       )
  (if (funcall (problema-solucao problema_in) estado) (list)
    (dolist (proxima_accao (funcall (problema-accoes problema_in) estado) -1)
	(setf proximoEstado (funcall function_resultado estado proxima_accao))
	(setf proximoProblema (make-problema :estado-inicial proximoEstado
                                             :solucao function_solucao
                                             :accoes function_accoes
                                             :resultado function_resultado
                                             :custo-caminho (problema-custo-caminho problema_in))
        (setf accoesa (procura-pp proximoProblema))
        (if (listp accoesa) (return (push proxima_accao accoes))))))))

#|(defstruct PROBLEMA estado-inicial solucao accoes resultado custo-caminho)
 => estado-inicial – contem o estado inicial do problema de procura;
 => solucao – função que recebe um estado e devolve T se o estado for uma solução para o problema de procura, e nil caso contrário;
 => accoes – função que recebe um estado e devolve uma lista com todas as acções que são
possíveis fazer nesse estado;
 => resultado – função que dado um estado e uma acção devolve o estado sucessor que
resulta de executar a acção recebida no estado recebido;
 => custo-caminho – função que dado um estado devolve o custo do caminho desde o estado inicial até esse estado |#


(defun procura-A* (problema heuristica)
)


(defun procura-best (tabuleiro pecas)
)
