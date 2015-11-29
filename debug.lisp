(defun procura-n-niveis (problema-in heuristica profundidade)
;   estado-inicial solucao accoes resultado custo-caminho
  (let (
        ( problema             NIL)
        ( melhor-problema      problema-in)
        ( test-melhor-problema NIL)
        ( estado-inicial       (problema-estado-inicial problema-in) )
       )
 
    (if (= profundidade 0) (progn (desenha-estado (problema-estado-inicial problema-in)) (read-char) (return-from procura-n-niveis melhor-problema)))
    
    (dolist (accao (funcall (problema-accoes problema-in)
                            (problema-estado-inicial problema-in)))
            (setf estado (funcall (problema-resultado problema-in)
                                  (problema-estado-inicial problema-in)
                                  accao))
            ;cria problema com o estado gerado
            (setf next-problema (copy-problema problema-in))
            (setf (problema-estado-inicial next-problema) estado)
            
            (setf test-melhor-problema (procura-n-niveis
                                          next-problema
                                          heuristica
                                          (1- profundidade)))

            (print (funcall heuristica (problema-estado-inicial test-melhor-problema)))
            (print (funcall heuristica (problema-estado-inicial melhor-problema)))
            (if (< (funcall heuristica (problema-estado-inicial test-melhor-problema))
                   (funcall heuristica (problema-estado-inicial melhor-problema)))
                (progn (print 'escolhiummelhor) (setf melhor-problema next-problema))))
      melhor-problema))

(defun heuristicaA4123 (estado-in)
  (let ((problema (make-problema :estado-inicial estado-in
                                 :solucao        'solucao
                                 :accoes         'accoes
                                 :resultado      'resultado
                                 :custo-caminho #'(lambda (estado) (* 0 (list-length (estado-pecas-colocadas estado))))))
        )
    (print 'ENTREINAHEURISTICADE4)
    (estado-pontos
      (problema-estado-inicial
        (procura-n-niveis
          problema #'(lambda (estado) (- 0 (estado-pontos estado))) 2)))))

 

;; Lista cheia de nodes do ( valorHeuristica ; estado )
;; Recebe lista + node a inserir
;(defun insereLista (lista node)
;  (if (or (eq lista NIL) (>= (cdar lista) (cdr node)))
;    (cons node lista)
;    (cons (car lista) (insereLista (cdr lista) node))))


;; Devolve n melhores sucessores de 1 problema
(defun gera-n-melhores (problema-in heuristica n)
  (let (( profundidade 1 )
        ( listaEstados NIL )
        ( proximoEstado NIL )
        ( listaAccoes NIL )
        )
    ;; Gerar todos as accoes possiveis a partir do estado inicial
    (setf listaAccoes (funcall (problema-accoes problema-in) (problema-estado-inicial problema-in) ))
    (setf nr-accoes (list-length listaAccoes))
    ;; Percorrer a lista de accoes
    (dolist (proxima-accao listaAccoes )
        ;; Gerar o estado resultante de cada accao
        ( setf proximoEstado (funcall (problema-resultado problema-in)
                                (problema-estado-inicial problema-in)
                                proxima-accao))

        ;; Avaliar estado a partir da heuristica
        ( setf valueEstado (funcall heuristica proximoEstado))
        ( setf listaEstados ( insereLista listaEstados (cons proximoEstado valueEstado) ))
  )
  (print 'fim)
  (print (min nr-accoes n))
  ( subseq listaEstados 0 (min nr-accoes n))
))


(defun procura-best (tabuleiro pecas)
  ;;FIXME
  (let ((problema (make-problema :estado-inicial
                                   (make-estado :pontos 0
                                                :pecas-por-colocar pecas
                                                :pecas-colocadas '()
                                                :tabuleiro (array->tabuleiro tabuleiro))
                                 :solucao   'solucao
                                 :accoes    'accoes
                                 :resultado 'resultado
                                 :custo-caminho #'(lambda (estado) (* 0 (list-length (estado-pecas-colocadas estado)))))))
  (procura-A* problema #'heuristicaA4123)))


;ppp que devolve n melhores estado
;funcao recebe problema; heuristica --> valor que melhor estado em
;funcao heuristica devolve
;
; Quero receber apenas estado
;
;
; ACCOES ; ESTADO ; RESULTADO


;estado-inicial solucao accoes resultado custo-caminho

;    (if (= profundidade 0)
;      (funcall heuristica estado-inicial)
;       (
;;        ;; Percorrer todas as acoes possiveis
;        (dolist (proxima-accao
;              (funcall (problema-accoes problema-in)
;                      (problema-estado problema-in)))
;
;          ;; Gerar o estado resultante de cada accao
;;          (setf proximoEstado
;                  (funcall (problema-resultado problema-in)
;                  (estado-tabuleiro (problema-estado problema-in))
 ;                     proxima-accao))
  ;        ;; Recriar o problema
   ;       (setf problema (make-problema estado-inicial: proximoEstado
    ;                                           solucao:))
     ;   )))))


#|
       (dolist (proxima-accao (funcall (problema-accoes problema-in) (problema-estado problema-in) ))
              (setf proximoEstado (funcall (problema-resultado problema-in) (problema-tabuleiro) proxima-accao)

))

                             (caar node) proxima_accao))

(+ (funcall (problema-custo-caminho problema-in)
            proximoEstado)
   (funcall heuristica proximoEstado))
|#
;;; Teste 25 E2
;;; procura-best num tabuleiro com 4 jogadadas por fazer. Os grupos tem um tempo limitado para conseguir obter pelo menos 500 pontos.
;;; deve retornar IGNORE
(ignore-value (setf a1 '#2A((T T T T NIL NIL T T T T)(T T T NIL NIL NIL T T T T)(T T T NIL NIL NIL T T T T)(T T T NIL NIL NIL T T T T)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL))))
;;;deve retornar IGNORE
(ignore-value (setf pecas '(t i l l)))
(setf r1 (procura-best a1 pecas))
(print r1)
(read-char)
;;;deve retornar T
(executa-jogadas (make-estado :tabuleiro (array->tabuleiro a1) :pecas-por-colocar pecas :pontos 0 :pecas-colocadas '()) r1 )
(quit)

