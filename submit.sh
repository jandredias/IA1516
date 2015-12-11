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
filename="stats1.xls"
if [ "$#" -eq  "0" ]
  then
  #clisp -i proj.lisp; kill -9 0
  cat testes.lisp >> proj.lisp
  clisp -i proj.lisp;

#  echo ""
#  echo -e -n "Version that loads debug"
#  echo -e -n "\e[33;1m Warning \e[0m"
#  echo ""
#  echo -e "\e[31m DO NOT SUBMIT\e[0m"
#  echo -e "\e[31m DO NOT SUBMIT\e[0m"
#  echo -e "\e[31m DO NOT SUBMIT\e[0m"
#  echo -e "\e[31m DO NOT SUBMIT\e[0m"
  echo -e "\e[33;1m Starting \e[0m"
  sleep 0.1
  { /usr/bin/time -f "%e"  clisp -i proj.lisp > /dev/null ;  } 2>  stats.txt
  cat stats.txt > ~/Dropbox/$filename
  echo -e "\e[33;1m Done \e[0m"
  sleep 0.1
  { /usr/bin/time -f "%e"  clisp -i proj.lisp > /dev/null ;  } 2>  stats.txt
  cat stats.txt >> ~/Dropbox/$filename
  echo -e "\e[33;1m Done \e[0m"
  sleep 0.1
  { /usr/bin/time -f "%e"  clisp -i proj.lisp > /dev/null ;  } 2>  stats.txt
  cat stats.txt >> ~/Dropbox/$filename
  echo -e "\e[33;1m Done \e[0m"
  sleep 0.1
  { /usr/bin/time -f "%e"  clisp -i proj.lisp > /dev/null ;  } 2>  stats.txt
  cat stats.txt >> ~/Dropbox/$filename
  echo -e "\e[33;1m Done \e[0m"
  sleep 0.1
  { /usr/bin/time -f "%e"  clisp -i proj.lisp > /dev/null ;  } 2>  stats.txt
  cat stats.txt >> ~/Dropbox/$filename
  sleep 0.1
  echo -e "\e[33;1m Done \e[0m"
  cat ~/Dropbox/$filename

  count=0;
  total=0;

  for i in $( awk '{ print $1; }' ~/Dropbox/$filename )
     do
       total=$(echo $total+$i | bc )
       ((count++))
     done
  echo "scale=2; $total / $count" | bc

  echo -e -n "\e[33;1m Warning \e[0m"
  echo -e -n "Version that loads debug"
  echo -e "\e[33;1m Warning \e[0m"
  read c;
  bash submit.sh

#  echo -e "\e[31m DO NOT SUBMIT\e[0m"
#  echo -e "\e[33;1m     FIXME \e[0m"
#  echo -e "\e[33;1m     FIXME \e[0m"
#  echo -e "\e[31m DO NOT SUBMIT\e[0m"#
#  echo -e "\e[33;1m     FIXME \e[0m"
#  echo -e "\e[33;1m     FIXME \e[0m"
#  echo -e "\e[31m DO NOT SUBMIT\e[0m"
#  echo -e "\e[33;1m     FIXME \e[0m"
#  echo -e "\e[33;1m     FIXME \e[0m"
#  echo -e "\e[31m DO NOT SUBMIT\e[0m"
else
  echo "File proj.lisp written!"
fi
