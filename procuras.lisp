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
(defvar *NIVEL* 0
  "Count of widgets made so far.")

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
      (incf *NIVEL*)
    	(setf proximoEstado (funcall function_resultado estado proxima_accao))
    	(setf proximoProblema (make-problema   :estado-inicial proximoEstado
                                             :solucao function_solucao
                                             :accoes function_accoes
                                             :resultado function_resultado
                                             :custo-caminho (problema-custo-caminho problema_in)))
        ;(format t "NIVEL: ~d" *NIVEL*)
        ;(desenha-estado proximoEstado)
        ;(read-char)
        (setf accoes (procura-pp proximoProblema))
        ;(decf *NIVEL*)
        (if (listp accoes) (return (push proxima_accao accoes)))))))

#|(defstruct PROBLEMA estado-inicial solucao accoes resultado custo-caminho)
 => estado-inicial – contem o estado inicial do problema de procura;
 => solucao – função que recebe um estado e devolve T se o estado for uma solução para o problema de procura, e nil caso contrário;
 => accoes – função que recebe um estado e devolve uma lista com todas as acções que são
possíveis fazer nesse estado;
 => resultado – função que dado um estado e uma acção devolve o estado sucessor que
resulta de executar a acção recebida no estado recebido;
 => custo-caminho – função que dado um estado devolve o custo do caminho desde o estado inicial até esse estado |#


(defun procura-A* (problema-in heuristica)
  (let* ((estado            (problema-estado-inicial problema-in))
        (listaAbertos       (criaLista (cons (cons estado NIL) (funcall (problema-custo-caminho problema-in) estado))))
        (node               )
        (proxima_accao NIL)
        (proximoEstado))

        (setf node (pop listaAbertos))

        (loop
            (if (funcall (problema-solucao problema-in) (caar node))
              (return (cdar node))
              ;else
              (progn
                ;gera as acoes a tomar para gerar os estados
                (dolist (proxima_accao (funcall (problema-accoes problema-in) (caar node)))

                  ;gera o estado tendo em conta cada accao
                  (setf proximoEstado (funcall (problema-resultado problema-in) (caar node) proxima_accao))

                  (print proximoEstado)
                  (read-char)
                  ;(setf listaAbertos (insereLista listaAbertos
                  ;                                (cons (cons proximoEstado (cons (cdar node) proxima_accao))
                  ;                                      (+ (funcall (problema-custo-caminho problema-in) proximoEstado) (funcall heuristica proximoEstado))
                  ;                                )))
                );end of dolist

                (setf node (pop listaAbertos));end of progn
                )))))

(defun procura-best (tabuleiro pecas)
;TODO
)

;;; Abstração de dados
;;; Stack ordenada por custos
(defun criaLista (node) (list node))
;;(defun removeLista (lista) (pop lista))
(defun insereLista (lista node)
  (if (or (eq lista NIL) (>= (cdar lista) (cdr node)))
    (cons node lista)
    (cons (car lista) (insereLista (cdr lista) node))))
