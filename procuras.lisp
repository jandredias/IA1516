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

;(defun procura-pp (problema-in)
;  (let ((result))
;    (setf result (procura-ppAux problema-in))
;    (if (eq -1 result) NIL result)))

(defun procura-pp (problema_in)
  (let ((estado      (problema-estado-inicial problema_in))
        (function_solucao (problema-solucao problema_in))
        (function_accoes  (problema-accoes problema_in))
        (function_resultado   (problema-resultado problema_in))
        (proximoProblema NIL)
        (proximoEstado NIL)
        (accoes NIL)
       )

  (if (funcall (problema-solucao problema_in) estado) T
    (progn
      (dolist (proxima_accao (funcall (problema-accoes problema_in) estado))
            (push proxima_accao accoes))
      (dolist (proxima_accao accoes NIL)
    	(setf proximoEstado (funcall function_resultado estado proxima_accao))
    	(setf proximoProblema (make-problema :estado-inicial proximoEstado
                                             :solucao function_solucao
                                             :accoes function_accoes
                                             :resultado function_resultado
                                             :custo-caminho
                                          (problema-custo-caminho problema_in)))
        (setf accoes (procura-pp proximoProblema))
        (if (eq accoes T) (return (list proxima_accao)))
        (if (not (null accoes))
            (return (push proxima_accao accoes))))))))

(defun procura-A* (problema-in heuristica)
  (let* ((estado       (problema-estado-inicial problema-in))
         (listaAbertos  (criaLista
                          (cons (cons estado NIL)
                               (funcall (problema-custo-caminho problema-in)
                                         estado))))
         (node)  
         (proximoEstado))
         (setf node (pop listaAbertos))
        (loop
            (if (funcall (problema-solucao problema-in) (caar node))
              (return (cdar node))
              ;else
              (progn
                ;gera as acoes a tomar para gerar os estados
                (dolist (proxima_accao (funcall (problema-accoes problema-in)
                                                (caar node)));end dolist header
                 
                  ;gera o estado tendo em conta cada accao
                  (setf proximoEstado (funcall (problema-resultado problema-in)
                                               (caar node) proxima_accao))

                  

                  ;BEGIN SETF LISTA ABERTOS
                  (setf listaAbertos
                    (insereLista listaAbertos
                      (cons (cons proximoEstado
                              (if (eq (cdar node) NIL)
                                  (list proxima_accao)
                                  (append (cdar node) (list proxima_accao))
                              )
                            )
                         (+ (funcall (problema-custo-caminho problema-in)
                                     proximoEstado)
                            (funcall heuristica proximoEstado)))))
                  ;END SETF LISTA ABERTOS
                );end of dolist
                (setf node (pop listaAbertos))
                (if (null node) (return NIL)))))))

(defun procura-best (tabuleiro pecas)
  (let ((problema (make-problema :estado-inicial proximoEstado 
                                 :solucao function_solucao
                                 :accoes function_accoes
                                 :resultado function_resultado
                                 :custo-caminho #'(lambda (x) 0))))))
;FIXME

;;; Abstracao de dados
;;; Stack ordenada por custos
(defun criaLista (node) (list node))
;;(defun removeLista (lista) (pop lista))
(defun insereLista (lista node)
  (if (or (eq lista NIL) (>= (cdar lista) (cdr node)))
    (cons node lista)
    (cons (car lista) (insereLista (cdr lista) node))))
