
;;; aggregate-height: estado --> inteiro
;;; This heuristic tell us how "high" a grid is.To compute the aggregate height,
;;; we take the sum of the height of each column (the distance from the highest
;;; tile in each column to the bottom of the grid).
(defun aggregate-height (estado-in)
  (let  ((sum 0)
        )
        (dotimes (coluna 10 sum)
                 (incf sum (tabuleiro-altura-coluna (estado-tabuleiro estado-in)
                                                    coluna)))))

;;; complete-lines: estado --> inteiro
;;; This is probably the most intuitive heuristic among the four. It is simply
;;; the the number of complete lines in a grid. We will want to maximize the
;;; number of complete lines, because clearing lines is the goal of the AI, and
;;; clearing lines will give us more space for more pieces.
(defun complete-lines (estado-in)
  (/ (estado-pontos estado-in) 100))

;;; holes: estado --> inteiro
;;; A hole is defined as an empty space such that there is at least one tile in
;;; the same column above it. A hole is harder to clear, because we will have to
;;; clear all the lines above it before we can reach the hole and fill it up.
;;; So we will have to minimize these holes.
(defun holes (estado-in)
  (let  ((sum 0)
        (tabuleiro (estado-tabuleiro estado-in))
        )
        (dotimes  (coluna 10 sum)
                  (progn
                    (dotimes (altura
                               (tabuleiro-altura-coluna
                                 (estado-tabuleiro estado-in) coluna))
                             (if (not (tabuleiro-preenchido-p tabuleiro altura coluna))
                                 (incf sum)))))))

;;; bumpiness: estado --> inteiro
;;; Consider a case where we get a deep "well" in our grid that makes it
;;; undesirable. The presence of these wells indicate that lines that can be
;;; cleared easily are not cleared. If a well were to be covered, all the rows
;;; which the well spans will be hard to clear. To generalize the idea of a
;;; "well", we define a heuristic which I shall name "bumpiness".
;;; The bumpiness of a grid tells us the variation of its column heights.
;;; It is computed by summing up the absolute differences between all two
;;; adjacent columns.
(defun bumpiness (estado-in)
  (let  ((sum 0))
        (dotimes (coluna 9 sum)
                 (incf sum (abs (- (tabuleiro-altura-coluna
                                     (estado-tabuleiro estado-in)
                                     coluna)
                                   (tabuleiro-altura-coluna
                                     (estado-tabuleiro estado-in)
                                     (1+ coluna))))))))

;;; heuristica: estado --> inteiro
;;;
(defun heuristica (estado-in)
  (let  ((a  0.510066)
         (b -0.860666)
         (c  0.356630)
         (d  0.184483))
        (+ (* a (aggregate-height estado-in))
           (* b (complete-lines estado-in))                                    
           (* c (holes estado-in))                                    
           (* d (bumpiness estado-in)))))
