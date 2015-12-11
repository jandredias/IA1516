(defun procura-n-niveis (problema-in heuristica profundidade)
;   estado-inicial solucao accoes resultado custo-caminho
  (let (
        ( problema             NIL)
        ( melhor-problema      problema-in)
        ( calculated-best      NIL)
        ( estado-inicial       (problema-estado-inicial problema-in) )
       )

    ;(if (= profundidade 0) (progn (desenha-estado (problema-estado-inicial problema-in)) (read-char) (return-from procura-n-niveis melhor-problema)))
    ;(if (= profundidade 0) (progn (desenha-estado (problema-estado-inicial problema-in)) (return-from procura-n-niveis melhor-problema)))
    (if (= profundidade 0) (return-from procura-n-niveis melhor-problema))

    (dolist (accao (funcall (problema-accoes problema-in)
                            (problema-estado-inicial problema-in)))
            (setf estado (funcall (problema-resultado problema-in)
                                  (problema-estado-inicial problema-in)
                                  accao))
            ;cria problema com o estado gerado
            (setf next-problema (copy-problema problema-in))
            (setf (problema-estado-inicial next-problema) estado)

            (setf calculated-best (procura-n-niveis
                                          next-problema
                                          heuristica
                                          (1- profundidade)))
			;(format t "profundidade: ~D" profundidade)
			;(format t "~%")
			;(format t "Calculado recursivo: ~,4f" (funcall heuristica (problema-estado-inicial calculated-best)))
			;(format t "~%")
			;(format t "Antigo melhor      : ~,4f" (funcall heuristica (problema-estado-inicial melhor-problema)))
			;(format t "~%")

            (if (< (funcall heuristica (problema-estado-inicial calculated-best))
                   (funcall heuristica (problema-estado-inicial melhor-problema)))
                (setf melhor-problema calculated-best)))
      melhor-problema))

(defun heuristicaA4123 (estado-in)
  (let ((problema (make-problema :estado-inicial estado-in
                                 :solucao        'solucao
                                 :accoes         'accoes
                                 :resultado      'resultado
                                 :custo-caminho #'(lambda (estado) (* 0 (list-length (estado-pecas-colocadas estado))))))
        )
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
        (listMaxSize 1500)
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

                  ;BEGIN SETF LISTA ABERTOS
                  ;(format t "variable: ~5d real: ~5d" currentSize (list-length listaAbertos))
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
                  ;END SETF LISTA ABERTOS
                );end of dolist
                (setf node (pop listaAbertos))
                (decf currentSize)
                (if (null node) (return NIL))))))))
;;; heuristica: estado --> inteiro
;;;

(defun heuristica (estado-in)
  (let  ((alturas  1)
         (buracos  256)
         (bumpi    100)
         (potencial 400))
		 (format t "alturas_t  : ~6f alturas  : ~6f" (* alturas (aggregate-height estado-in)) (aggregate-height estado-in))
		 (format t "~%")
		 (format t "buracos_t  : ~6f buracos  : ~6f" (* buracos (holes estado-in)) (holes estado-in))
		 (format t "~%")
		 (format t "bumpiness_t: ~6f bumpiness: ~6f" (* bumpi (bumpiness estado-in)) (bumpiness estado-in))
		 (format t "~%")
		 (format t "potencial_t: ~6f potencial: ~6f" (* potencial (potencial-diferente estado-in)) (potencial-diferente estado-in))
		 (format t "~%")
		 (format t "~%")
		 (format t "~%")
         (+ (* alturas (aggregate-height estado-in))
           (* buracos (holes estado-in))
           (* potencial (potencial-diferente estado-in))
           (* bumpi (bumpiness estado-in)))))


;;; Teste 25 E2
;;; procura-best num tabuleiro com 4 jogadadas por fazer. Os grupos tem um tempo limitado para conseguir obter pelo menos 500 pontos.
;;; deve retornar IGNORE
(ignore-value (setf a1 '#2A((T T T T NIL NIL T T T T)(T T T NIL NIL NIL T T T T)(T T T NIL NIL NIL T T T T)(T T T NIL NIL NIL T T T T)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL)(NIL NIL NIL NIL NIL NIL NIL NIL NIL NIL))))
;;;deve retornar IGNORE
(ignore-value (setf pecas '(t l j l i l)))
;;; Teste 11 E2 - correspondente ao Teste 18 publicado na fase 1 mas que nao chegou a ser testado na fase 1
;;; Testes fn resultado com pecas mais dificeis
;;deve retornar IGNORE
(ignore-value (setf estado1 (make-estado :pontos 0 :pecas-por-colocar PECAS :pecas-colocadas '() :tabuleiro (array->tabuleiro a1))))

#|(setf problema-in (make-problema :estado-inicial estado1
                                 :solucao        'solucao
                                 :accoes         'accoes
                                 :resultado      'resultado
                                 :custo-caminho #'(lambda (estado) (* 2 (list-length (estado-pecas-colocadas estado))))))|#
;(setf a (procura-n-niveis problema-in #'complete-lines 2))
;(print a)
;(read-char)
(setf r1 (procura-best a1 pecas))
(print r1)
;(read-char)
;;;deve retornar T
;(executa-jogadas (make-estado :tabuleiro (array->tabuleiro a1) :pecas-por-colocar pecas :pontos 0 :pecas-colocadas '()) r1 )
;(ignore-value (setf estado2 (make-estado :pontos 0 :pecas-por-colocar PECAS :pecas-colocadas '() :tabuleiro (array->tabuleiro a2))))
;(SETf r1 ((0 . #2A((T T T) (T NIL NIL)) ) (0 . #2A((T T T) (T NIL NIL)) ) )

(executa-jogadas (make-estado :tabuleiro (array->tabuleiro a1) :pecas-por-colocar pecas :pontos 0 :pecas-colocadas '()) r1 )
(quit)
