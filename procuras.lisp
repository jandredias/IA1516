;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PROCURAS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; descricao
;;;   Resolve um problema que a estrutura recebida represente
;;;   O prob e resolvido usando uma procura em profundidade primeiro em arvore
;;; @param struct problema
;;; @return lista de acoes

;;; procura-pp: problema -> lista accoes
;;; Esta funcao recebe um problema e usa a procura em profundidade primeiro em
;;; arvore para obter uma solucao para resolver o problema. Devolve uma lista de
;;; accoes que se executada pela ordem especificada ira levar do estado inicial
;;; a um estado objectivo. Deve ser utilizado um criterio de Last In First Out,
;;; pelo que o ultimo no a ser colocado na fronteira devera ser o primeiro a ser
;;; explorado a seguir. Devem tambem ter o cuidado do algoritmo ser independente
;;; do problema, ou seja devera funcionar para este problema do Tetris, mas
;;; devera funcionar tambem para qualquer outro problema de procura.
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

;;; procura-A*: problema x heuristica -> lista accoes
;;; Esta funcao recebe um problema e uma funcao heuristica, e utiliza o
;;; algoritmo de procura A* em arvore para tentar determinar qual a sequencia de
;;; accoes de modo a maximizar os pontos obtidos. A funcao heuristica
;;; corresponde a uma funcao que recebe um estado e devolve um numero, que
;;; representa a estimativa do custo/qualidade a partir desse estado ate ao
;;; melhor estado objectivo. Em caso de empate entre dois nos com igual valor de
;;; f na lista deve ser escolhido o ultimo a ter sido colocado na fronteira.
;;; Devem tambem ter o cuidado do algoritmo ser independente do problema.
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

;;; procura-best: array x lista pecas -> lista accoes
;;; Esta funcao recebe um array correspondente a um tabuleiro e uma lista de
;;; pecas por colocar, inicializa o estado e a estrutura problema com as funcoes
;;; escolhidas pelo grupo, e ira usar a melhor procura e a melhor heuristica e
;;; melhor funcao custo/qualidade feita pelo grupo para obter a sequencia de
;;; accoes de modo a conseguir colocar todas as pecas no tabuleiro com o maximo
;;; de pontuacao. No entanto, tenham em consideracao que esta funcao ira ter um
;;; limite de tempo para retornar um resultado, portanto nao vos serve de nada
;;; retornar a solucao optima se excederem o tempo especificado. E importante
;;; encontrar um compromisso entre a pontuacao obtida e o tempo de execucao do
;;; algoritmo. Esta funcao ira ser a funcao usada para avaliar a qualidade da
;;; vossa versao final. Se assim o entenderem, nesta funcao ja podem usar
;;; implementacoes e optimizacoes especificas para o jogo do Tetris.
;;; E importante ter em conta, que para alem destas funcoes explicitamente
;;; definidas (que serao testadas automaticamente), na 2a fase do projecto
;;; deverao implementar tecnicas adicionais de optimizacao, varias heuristicas,
;;; ou ate mesmo funcoes de custo alternativas, e testa-las. Cabe aos alunos
;;; decidir que tecnicas/heuristicas adicionais irao precisar para que o vosso
;;; algoritmo final procura-best seja o melhor possivel.
(defun procura-best (tabuleiro pecas)
  (let ((problema-in (make-problema :estado-inicial
                                   (make-estado :pontos 0
                                                :pecas-por-colocar pecas
                                                :pecas-colocadas '()
                                                :tabuleiro (array->tabuleiro tabuleiro))
                                 :solucao   'solucao
                                 :accoes    'accoes
                                 :resultado 'resultado
                                 :custo-caminho #'qualidade))
        (listMaxSize 1000)
        (currentSize 0)
        )
  (let* ((heuristica #'heuristica)
		 (estado       (problema-estado-inicial problema-in))
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
                  (setf listaAbertos
                    (subseq (insereLista listaAbertos
                      (cons (cons proximoEstado
                              (if (eq (cdar node) NIL)
                                  (list proxima_accao)
                                  (append (cdar node) (list proxima_accao))
                              )
                            )
                         (+ (funcall (problema-custo-caminho problema-in)
                                     proximoEstado)
                            (funcall heuristica proximoEstado)))) 0 (min currentSize listMaxSize)))
                   (incf currentSize)
                );end of dolist
                (setf node (pop listaAbertos))
                (decf currentSize)
                (if (null node) (return NIL))))))))

;;; Abstracao de dados
;;; Stack ordenada por custos
(defun criaLista (node) (list node))

;;(defun removeLista (lista) (pop lista))

;;                                 FIXME nao sei se ordem esta certa
;; Lista cheia de nodes do tipo ( (estado;acoes) ; valorHeuristica  )
;; Recebe lista + node a inserir
(defun insereLista (lista node)
  (if (or (eq lista NIL) (>= (cdar lista) (cdr node)))
    (cons node lista)
    (cons (car lista) (insereLista (cdr lista) node))))
