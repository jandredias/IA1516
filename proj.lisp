;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Grupo 66 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 75741 João Figueiredo
;;; 75966 Frederico Moura
;;; 78865 Miguel Amaral
(load "tabuleiro.lisp")
(load "accao.lisp")
(load "estado.lisp")
(defun formulacao-problema (a b))
(load (compile-file "utils.lisp"))
(load "function_search.lisp")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PROBLEMA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defstruct PROBLEMA estado-inicial solucao accoes resultado custo-caminho)

;;;;DELETE;;;;DELETE;;;;DELETE;;;;DELETE;;;;DELETE;;;;DELETE;;;;DELETE;;;;DELETE;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DEBUG ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setf tab1 (cria-tabuleiro))

;; Coluna 1 Preenchida
(tabuleiro-preenche! tab1 0 0)
(tabuleiro-preenche! tab1 1 0)
(tabuleiro-preenche! tab1 2 0)
(tabuleiro-preenche! tab1 3 0)
(tabuleiro-preenche! tab1 4 0)
(tabuleiro-preenche! tab1 5 0)
(tabuleiro-preenche! tab1 6 0)
(tabuleiro-preenche! tab1 7 0)
(tabuleiro-preenche! tab1 8 0)
(tabuleiro-preenche! tab1 9 0)
(tabuleiro-preenche! tab1 10 0)
(tabuleiro-preenche! tab1 11 0)
(tabuleiro-preenche! tab1 12 0)
(tabuleiro-preenche! tab1 13 0)
(tabuleiro-preenche! tab1 14 0)
(tabuleiro-preenche! tab1 15 0)
(tabuleiro-preenche! tab1 16 0)
(tabuleiro-preenche! tab1 17 0)
(tabuleiro-preenche! tab1 17 1)
(tabuleiro-preenche! tab1 17 2)
(tabuleiro-preenche! tab1 17 3)
(tabuleiro-preenche! tab1 17 4)

(tabuleiro-preenche! tab1 0 1)
(tabuleiro-preenche! tab1 0 2)
(tabuleiro-preenche! tab1 0 3)
(tabuleiro-preenche! tab1 0 4)
(tabuleiro-preenche! tab1 0 5)
(tabuleiro-preenche! tab1 0 6)
(tabuleiro-preenche! tab1 0 7)
(tabuleiro-preenche! tab1 0 8)




(tabuleiro-preenche! tab1 1 1)
(tabuleiro-preenche! tab1 2 1)
(tabuleiro-preenche! tab1 3 1)
(tabuleiro-preenche! tab1 3 2)

(tabuleiro-preenche! tab1 1 2)
(tabuleiro-preenche! tab1 1 3)
(tabuleiro-preenche! tab1 2 2)
(tabuleiro-preenche! tab1 4 1)
(tabuleiro-preenche! tab1 4 2)
tab1

(tabuleiro-altura-coluna tab1 0)
(tabuleiro-altura-coluna tab1 1)
(tabuleiro-altura-coluna tab1 2)
(tabuleiro-altura-coluna tab1 9)
;(setf array (array-slice tab_8_esq 0))
(tabuleiro-linha-completa-p tab1 0)
(tabuleiro-topo-preenchido-p tab1)
;tabuleiros-iguais tab1 tab1)
(setf tab2 (copia-tabuleiro tab1))
(defun preenche-tudo (tab)
  (dotimes (i 18 tab)
    (dotimes (j 10)
        (tabuleiro-preenche! tab i j)
    )
  )
)
(setf tab_9_esq (preenche-tudo (cria-tabuleiro)))
(defun preenche-diagonal (tab)
  (dotimes (i 18 tab)
    (dotimes (j 10)
      (cond ((> j i)
        (tabuleiro-preenche! tab i j)
        )
      )
    )
  )
)
(setf tab_8_esq (preenche-diagonal (cria-tabuleiro)))
tab_8_esq
