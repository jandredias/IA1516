;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PROBLEMA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; O tipo problema representa um problema generico de procura. Este tipo devera
;;; ser implementado obrigatoriamente como uma estrutura em Common Lisp com os
;;; seguintes campos:
;;; -> estado-inicial - contem o estado inicial do problema de procura;
;;; -> solucao - funcao que recebe um estado e devolve T se o estado for uma
;;;    solucao para o problema de procura, e nil caso contrario;
;;; -> accoes - funcao que recebe um estado e devolve uma lista com todas as
;;;    accoes que sao possiveis fazer nesse estado;
;;; -> resultado - funcao que dado um estado e uma accao devolve o estado
;;;    sucessor que resulta de executar a accao recebida no estado recebido;
;;; -> custo-caminho - funcao que dado um estado devolve o custo do caminho
;;;    desde o estado inicial ate esse estado.
(defstruct PROBLEMA estado-inicial solucao accoes resultado custo-caminho)

