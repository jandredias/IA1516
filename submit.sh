rm proj.lisp -rf
cat header.lisp >> proj.lisp
cat tabuleiro.lisp >> proj.lisp
cat accao.lisp >> proj.lisp
cat estado.lisp >> proj.lisp
cat function_search.lisp >> proj.lisp
cat problema.lisp >> proj.lisp
cat heuristicas.lisp >> proj.lisp
cat procuras.lisp >> proj.lisp
cat loader.lisp >> proj.lisp


if [ "$#" -eq  "0" ]
  then
  cat debug.lisp >> proj.lisp
  echo ""
  echo -e -n "\e[33;1m Warning \e[0m"
  echo -e -n "Version that loads debug"
  echo -e "\e[33;1m Warning \e[0m"
  echo ""
  echo -e "\e[31m DO NOT SUBMIT\e[0m"
  echo -e "\e[31m DO NOT SUBMIT\e[0m"
  echo -e "\e[31m DO NOT SUBMIT\e[0m"
  echo -e "\e[31m DO NOT SUBMIT\e[0m"
  read -n 1 c
  clisp -i proj.lisp
  echo -e -n "\e[33;1m Warning \e[0m"
  echo -e -n "Version that loads debug"
  echo -e "\e[33;1m Warning \e[0m"
  echo -e "\e[31m DO NOT SUBMIT\e[0m"
  echo -e "\e[31m DO NOT SUBMIT\e[0m"
  echo -e "\e[31m DO NOT SUBMIT\e[0m"
  echo -e "\e[31m DO NOT SUBMIT\e[0m"
else
  echo "File proj.lisp written!"
fi
