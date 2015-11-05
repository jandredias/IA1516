;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Grupo 66 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 75741 João Figueiredo
;;; 75966 Frederico Moura
;;; 78865 Miguel Amaral
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "tabuleiro.lisp")
(load "accao.lisp")
(load "estado.lisp")
(defun formulacao-problema (a b))
(load "function_search.lisp")
(load (compile-file "utils.lisp"))
(load "debug.lisp")




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PROBLEMA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defstruct PROBLEMA estado-inicial solucao accoes resultado custo-caminho)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DEBUG ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
