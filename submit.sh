rm proj.lisp -rf
cat header.lisp >> proj.lisp
cat tabuleiro.lisp >> proj.lisp
cat accao.lisp >> proj.lisp
cat estado.lisp >> proj.lisp
cat function_search.lisp >> proj.lisp
cat problema.lisp >> proj.lisp
cat procuras.lisp >> proj.lisp
cat loader.lisp >> proj.lisp


if [ "$#" -eq  "0" ]
  then
  clisp -i proj.lisp
else
  echo "File proj.lisp written!"
fi
