# IA1516

1| Introducao
-------------

Neste projecto pretende-se implementar um algoritmo de procura capaz de jogar uma variante do jogo Tetris, em que as pecas por colocar sao conhecidas a partida. O objectivo e tentar maximizar o numero de pontos com as pecas definidas. Para simplificar o jogo, so e permitido ao jogador escolher a rotacao e a posicao onde a peca ira cair. Uma vez escolhida a rotacao e a posicao, a peca devera cair a direito sem qualquer movimento adicional. 

O tabuleiro do jogo e constituido por 10 colunas e 18 linhas. As linhas estao numeradas de 0 a 17, e as colunas de 0 a 9. Cada posicao do tabuleiro pode estar vazia ou ocupada. Assim que uma peca e colocada sobre o tabuleiro, se existir alguma posicao ocupada na linha 17 o jogo termina. Caso Pecas por colocar contrario, todas as linhas que estejam completas[1] sao removidas e o jogador ganha o seguinte numero de pontos em funcao do numero de linhas removidas:

| Linhas | Pontos |
|-----------------|
|     1  | 100    |
|     2  | 300    |
|     3  | 500    |
|     4  | 800    |

Quando uma linha e removida, as linhas superiores a essa linha deverao descer como se vê na figura seguinte.

2| Trabalho a realizar
----------------------

O objectivo do projecto e escrever um programa em Common Lisp, que utilize tecnicas de procura sistematica, para determinar a sequência de accoes de modo a conseguir colocar todas as pecas e tentando maximizar o numero de pontos obtidos.
Para tal deverao realizar varias tarefas que vao desde a implementacao dos tipos de dados usados na representacao do tabuleiro, ate a implementacao dos algoritmos de procura e de heuristicas para guiar os algoritmos. Uma vez implementados os algoritmo de procura, os alunos deverao fazer um estudo/analise comparativa das varias versoes dos algoritmos, bem como das funcoes heuristicas implementadas.
Nao e necessario testarem os argumentos recebidos pelas funcoes, a nao ser que seja indicado explicitamente para o fazerem. Caso nao seja dito nada, podem assumir que os argumentos recebidos por uma funcao estao sempre correctos.

2.1 | Tipos Abstractos de Informacao
------------------------------------

2.1.1 | Tipo Accao
------------------

O tipo Accao e utilizado para representar uma accao do jogador. Uma accao e implementada como um par cujo elemento esquerdo e um numero de coluna que indica a coluna mais a esquerda escolhida para a peca cair, e cujo elemento direito corresponde a um array bidimensional com a configuracao geometrica da peca depois de rodada[2]. A figura seguinte mostra o exemplo de uma accao. O ficheiro utils.lisp define todas as configuracoes geometricas possiveis para cada peca[3].

 -> cria-accao: inteiro x array -> accao
    Este construtor recebe um inteiro correspondente a posicao da coluna mais a esquerda a partir da qual a peca vai ser colocada, e um array com a configuracao da peca a colocar, e devolve uma nova accao.

  -> accao-coluna: accao -> inteiro
    Este selector devolve um inteiro correspondente a coluna mais a esquerda a partir da qual a
peca vai ser colocada.

  -> accao-peca: accao -> array
    Este selector devolve o array com a configuracao geometrica exacta com que vai ser colocada.

2.1.2 | Tipo tabuleiro
----------------------

O tipo Tabuleiro e utilizado para representar o tabuleiro do jogo de Tetris com 18 linhas e 10 colunas, em que cada posicao do tabuleiro pode estar preenchida ou nao. Cabe aos alunos a escolha da representacao mais adequada para este tipo.
  -> cria-tabuleiro: {} -> tabuleiro
    Este construtor nao recebe qualquer argumento, e devolve um novo tabuleiro vazio.

  -> copia-tabuleiro: tabuleiro -> tabuleiro
    Este construtor recebe um tabuleiro, e devolve um novo tabuleiro com o mesmo conteudo do tabuleiro recebido. O tabuleiro devolvido deve ser um objecto computacional diferente e devera garantir que qualquer alteracao feita ao tabuleiro original nao deve ser repercutida no novo tabuleiro e vice-versa.
  -> tabuleiro-preenchido-p: tabuleiro x inteiro x inteiro -> logico
    Este selector recebe um tabuleiro, um inteiro correspondente ao numero da linha e um inteiro correspondente ao numero da coluna, e devolve o valor logico verdade se essa posicao estiver preenchida, e falso caso contrario.
  -> tabuleiro-altura-coluna: tabuleiro x inteiro -> inteiro
    Este selector recebe um tabuleiro, um inteiro correspondente ao numero de uma coluna, e devolve a altura de uma coluna, ou seja a posicao mais alta que esteja preenchida dessa coluna. Uma coluna que nao esteja preenchida devera ter altura 0.
  -> tabuleiro-linha-completa-p: tabuleiro x inteiro -> logico
    Este reconhecedor recebe um tabuleiro, um inteiro correspondente ao numero de uma linha, e devolve o valor logico verdade se todas as posicoes da linha recebida estiverem preenchidas, e falso caso contrario.
  -> tabuleiro-preenche!: tabuleiro x inteiro x inteiro -> {}
    Este modificador recebe um tabuleiro, um inteiro correspondente ao numero linha e um inteiro correspondente ao numero da coluna, e altera o tabuleiro recebido para na posicao correspondente a linha e coluna passar a estar preenchido. Se o numero de linha e de coluna recebidos nao forem validos (i.e. nao estiverem entre 0 e 17, e 0 e 9), esta funcao nao devera fazer nada. O valor devolvido por desta funcao nao esta definido[4].
  -> tabuleiro-remove-linha!: tabuleiro x inteiro -> {}
    Este modificador recebe um tabuleiro, um inteiro correspondente ao numero de linha, e altera o tabuleiro recebido removendo essa linha do tabuleiro, e fazendo com que as linhas por cima da linha removida descam uma linha. As linhas que estao por baixo da linha removida nao podem ser alteradas. O valor devolvido por desta funcao nao esta definido.
  -> tabuleiro-topo-preenchido-p: tabuleiro -> logico
    Este reconhecedor recebe um tabuleiro, e devolve o valor logico verdade se existir alguma posicao na linha do topo do tabuleiro (linha 17) que esteja preenchida, e falso caso contrario.
  -> tabuleiros-iguais-p: tabuleiro x tabuleiro -> logico
    Este teste recebe dois tabuleiros, e devolve o valor logico verdade se os dois tabuleiros forem iguais (i.e. tiverem o mesmo conteudo), e falso caso contrario.
  -> tabuleiro->array: tabuleiro -> array
    Este transformador de saida recebe um tabuleiro e devolve um novo array com 18 linhas e 10 colunas, que para cada linha e coluna devera conter o valor logico correspondente a cada posicao do tabuleiro. O array retornado devera garantir que qualquer alteracao feita ao tabuleiro original nao deve ser repercutida no novo array e vice-versa.
  -> array->tabuleiro: array -> tabuleiro
    Este transformador de entrada recebe um array com 18 linhas e 10 colunas cujas posicoes têm o valor logico T ou Nil, e constroi um novo tabuleiro com o conteudo do array recebido. O tabuleiro devolvido devera garantir que qualquer alteracao feita ao array original nao deve ser repercutida no novo tabuleiro e vice-versa.

2.1.3 | Tipo Estado
-------------------

O tipo estado representa o estado de um jogo de Tetris. Este tipo devera ser implementado obrigatoriamente como uma estrutura[5] em Common Lisp com os seguintes campos:

  -> pontos – o numero de pontos conseguidos ate ao momento no jogo;
  -> pecas-por-colocar – uma lista com as pecas que ainda estao por colocar, pela ordem de
colocacao. As pecas nesta lista sao representadas pelo simbolo correspondente a letra da peca, i.e. i,j,l,o,s,z,t[6];
  -> pecas-colocadas – uma lista com as pecas ja colocadas no tabuleiro (representadas tambem
pelo simbolo). Esta lista deve encontrar-se ordenada da peca mais recente para a mais antiga;
  -> Tabuleiro – o tabuleiro com as posicoes actualmente preenchidas do jogo.

Para alem das operacoes construidas automaticamente para estruturas (ex: selectores e modificadores), devera implementar os seguintes operadores adicionais sobre estados.
  -> copia-estado: estado -> estado
    Este construtor recebe um estado e devolve um novo estado cujo conteudo deve ser copiado a partir do estado original. O estado devolvido devera garantir que qualquer alteracao feita ao estado original nao deve ser repercutida no novo estado e vice-versa.
  -> estados-iguais-p: estado x estado -> logico
    Este teste recebe dois estados, e devolve o valor logico verdade se os dois estados forem iguais (i.e. tiverem o mesmo conteudo) e falso caso contrario.
  -> estado-final-p: estado -> logico
    Este reconhecedor recebe um estado e devolve o valor logico verdade se corresponder a um estado final onde o jogador ja nao possa fazer mais jogadas e falso caso contrario. Um estado e considerado final se o tabuleiro tiver atingido o topo ou se ja nao existem pecas por colocar.

2.1.4 | Tipo problema
---------------------

O tipo problema representa um problema generico de procura. Este tipo devera ser implementado obrigatoriamente como uma estrutura em Common Lisp com os seguintes campos:
  -> estado-inicial – contem o estado inicial do problema de procura;
  -> solucao – funcao que recebe um estado e devolve T se o estado for uma solucao para o problema de procura, e nil caso contrario;
  -> accoes – funcao que recebe um estado e devolve uma lista com todas as accoes que sao possiveis fazer nesse estado;
  -> resultado – funcao que dado um estado e uma accao devolve o estado sucessor que resulta de executar a accao recebida no estado recebido;
  -> custo-caminho – funcao que dado um estado devolve o custo do caminho desde o estado inicial ate esse estado.

2.2 | Funcoes a implementar
---------------------------

Para alem dos tipos de dados especificados na seccao anterior, e obrigatoria tambem a implementacao das seguintes funcoes.

2.2.1 | Funcoes do problema de procura
--------------------------------------

Estas funcoes podem ser usadas como funcoes do problema de procura, que depois serao usadas pelos algoritmos de procura:
  -> solucao: estado -> logico
    Esta funcao recebe um estado, e devolve o valor logico verdade se o estado recebido corresponder a uma solucao, e falso contrario. Um estado do jogo Tetris e considerado solucao se o topo do tabuleiro nao estiver preenchido e se ja nao existem pecas por colocar, ou seja, todas as pecas foram colocadas com sucesso (independentemente de terem ou nao sido obtidos pontos).
  -> accoes: estado -> lista de accoes
    Esta funcao recebe um estado e devolve uma lista de accoes correspondendo a todas as accoes validas que podem ser feitas com a proxima peca a ser colocada. Uma accao e considerada valida mesmo que faca o jogador perder o jogo (i.e. preencher a linha do topo). Uma accao e invalida se nao for fisicamente possivel dentro dos limites laterais do jogo[7][8]. Por exemplo colocar a peca i deitada na ultima coluna do tabuleiro, ou tentar colocar a peca s com a
orientacao inicial na coluna 8[9], tal como se pode ver na imagem seguinte.
Figura 4- Exemplo de accao invalida

A ordem com que sao devolvidas as accoes na lista e muito importante. À frente da lista devem estar obrigatoriamente as accoes correspondentes a orientacao inicial da peca, percorrendo todas as colunas possiveis da esquerda para a direita. Depois e escolhida uma nova orientacao, rodando a peca 90o no sentido horario, e volta-se a gerar para todas as colunas possiveis da esquerda para a direita. No entanto, se ao rodar uma peca obter uma configuracao geometrica
ja explorada anteriormente (como por exemplo no caso da peca O em que todas as rotacoes correspondem a mesma configuracao) nao devem ser geradas novamente as accoes[10].

  -> resultado: estado x accao -> estado
    Esta funcao recebe um estado e uma accao, e devolve um novo estado que resulta de aplicar a accao recebida no estado original. Atencao, o estado original nao pode ser alterado em situacao alguma. Esta funcao deve actualizar as listas de pecas, colocar a peca especificada pela accao na posicao correcta do tabuleiro. Depois de colocada a peca, e verificado se o topo do tabuleiro esta preenchido. Se estiver, nao se removem linhas e devolve-se o estado. Se nao estiver, removem-se as linhas e calculam-se os pontos obtidos.
  -> qualidade: estado -> inteiro
    Os algoritmos de procura informada estao concebidos para tentar minimizar o custo de caminho. No entanto, se quisermos maximizar os pontos obtidos, podemos olhar para isto como um problema de maximizacao de qualidade. Para podermos usar a qualidade com os algoritmos de procura melhor primeiro, uma solucao simples e convertermos a qualidade num valor negativo de custo. Assim sendo, um estado com mais pontos ira ter um valor menor (negativo) e
tera prioridade para o mecanismo de escolha do proximo no a ser expandido.
Portanto, a funcao qualidade recebe um estado e retorna um valor de qualidade que corresponde ao valor negativo dos pontos ganhos ate ao momento.
  -> custo-oportunidade: estado -> inteiro
    Uma representacao alternativa para um problema de maximizacao de qualidade, e considerar que por cada accao podemos potencialmente ganhar um determinado valor, e que o custo e dado pelo facto de nao conseguirmos ter aproveitado ao maximo a oportunidade. Assim sendo o custo de oportunidade pode ser calculado como a diferenca entre o maximo possivel e o efetivamente conseguido. Portanto esta funcao, dado um estado, devolve o custo de oportunidade de todas as accoes realizadas ate ao momento, assumindo que e sempre possivel fazer o maximo de pontos por cada peca colocada[11]. Ao usarmos esta funcao como custo, os algoritmos de procura irao tentar minimizar o custo de oportunidade.

2.2.2 | Procuras
----------------

As funcoes descritas nesta subseccao correspondem aos algoritmos de procura a implementar para determinar a sequência de accoes de modo a colocar todas as pecas.
  
  -> procura-pp: problema -> lista accoes 
    Esta funcao recebe um problema e usa a procura em profundidade primeiro em arvore para obter uma solucao para resolver o problema. Devolve uma lista de accoes que se executada pela ordem especificada ira levar do estado inicial a um estado objectivo. Deve ser utilizado um criterio de Last In First Out, pelo que o ultimo no a ser colocado na fronteira devera ser o primeiro a ser explorado a seguir. Devem tambem ter o cuidado do algoritmo ser independente
do problema, ou seja devera funcionar para este problema do Tetris, mas devera funcionar tambem para qualquer outro problema[12] de procura.
  -> procura-A*: problema x heuristica -> lista accoes
    Esta funcao recebe um problema e uma funcao heuristica, e utiliza o algoritmo de procura A* em arvore para tentar determinar qual a sequência de accoes de modo a maximizar os pontos obtidos. A funcao heuristica corresponde a uma funcao que recebe um estado e devolve um numero, que representa a estimativa do custo/qualidade[13] a partir desse estado ate ao melhor estado objectivo. Em caso de empate entre dois nos com igual valor de f na lista deve ser
escolhido o ultimo a ter sido colocado na fronteira. Devem tambem ter o cuidado do algoritmo ser independente do problema.
  -> procura-best: array x lista pecas -> lista accoes
    Esta funcao recebe um array correspondente a um tabuleiro e uma lista de pecas por colocar, inicializa o estado e a estrutura problema com as funcoes escolhidas pelo grupo, e ira usar a melhor procura e a melhor heuristica e melhor funcao custo/qualidade feita pelo grupo para obter a sequência de accoes de modo a conseguir colocar todas as pecas no tabuleiro com o maximo de pontuacao. No entanto, tenham em consideracao que esta funcao ira ter um limite
de tempo para retornar um resultado, portanto nao vos serve de nada retornar a solucao optima se excederem o tempo especificado[14]. É importante encontrar um compromisso entre a pontuacao obtida e o tempo de execucao do algoritmo. Esta funcao ira ser a funcao usada para avaliar a qualidade da vossa versao final. Se assim o entenderem, nesta funcao ja podem usar implementacoes e optimizacoes especificas para o jogo do Tetris.
É importante ter em conta, que para alem destas funcoes explicitamente definidas (que serao testadas automaticamente), na 2.ª fase do projecto deverao implementar tecnicas adicionais de optimizacao, varias heuristicas, ou ate mesmo funcoes de custo alternativas, e testa-las. Cabe aos alunos decidir que tecnicas/heuristicas adicionais irao precisar para que o vosso algoritmo final procura-best seja o melhor possivel.

2.3 | Estudo e analise dos algoritmos e heuristicas implementadas
-----------------------------------------------------------------

Na parte final do projecto, e obrigatorio os alunos compararem as diferentes variantes das procuras, algoritmos e heuristicas usadas para resolver o jogo do Tetris especificado, e perceberem as diferencas entre elas. Para isso deverao medir varios factores relevantes, e comparar os algoritmos num conjunto significativo de exemplos. Deverao tambem tentar analisar/justificar o porquê dos resultados obtidos.
Os resultados dos testes efectuados deverao ser usados para escolher as melhores procuras e as melhores funcoes de custo/heuristicas a serem usadas. Esta escolha devera ser devidamente justificada no relatorio do projecto.
Nesta fase final e tambem pretendido que os alunos escrevam um relatorio sobre o projecto realizado.
Para alem dos testes efectuados e da analise correspondente, o relatorio do projecto devera conter tambem informacao acerca da implementacao de alguns tipos e funcoes. Por exemplo, qual a representacao escolhida para cada tipo (e porquê), qual a funcao de utilidade utilizada, como foram implementas as procuras e que optimizacoes foram efectuadas, quais as funcoes heuristicas implementadas e como e que foram implementadas, etc. Sera disponibilizado um template do relatorio para que os alunos tenham uma ideia melhor do que e necessario incluir no relatorio final do projecto.

3 | Ficheiro utils
------------------

Foi fornecido um ficheiro de utilitarios juntamente com o enunciado, que define a configuracao geometrica para cada rotacao possivel de cada peca. Para alem disso, fornece tambem um conjunto de funcoes para gerar tabuleiros aleatorios e listas de pecas aleatorias. Mas mais importante, o ficheiro utils fornece uma funcao muito util para visualizar a execucao das jogadas devolvidas pelo vosso algoritmo de procura, e testar assim a qualidade das vossas funcoes.
A funcao executa-jogadas recebe um estado inicial e uma lista de accoes (a lista devolvida por um algoritmo de procura), e vai desenhando o estado resultante de ir colocar as pecas de acordo com as accoes recebidas, mostrando os pontos obtidos. Para avancar entre ecras, devera premir a tecla “Enter”.

Figura 5- Exemplo de visualizacao usando a funcao executa-jogadas

4 | Entregas, Prazos, Avaliacao e Condicoes de Realizacao
---------------------------------------------------------

4.1 | Entregas e Prazos
-----------------------

A realizacao do projecto divide-se em 3 entregas. As duas primeiras entregas correspondem a implementacao do codigo do projecto, enquanto que a 3.ª entrega corresponde a entrega do relatorio do projecto. 

4.1.1 | 1.ª Entrega
-----------------

Na primeira entrega pretende-se que os alunos implementem os tipos de dados descritos no enunciado (seccao 2.1) bem como as funcoes correspondentes a seccao 2.2.1. A entrega desta primeira parte sera feita por via electronica atraves do sistema Mooshak, ate as 23:59 do dia 09/11/2014. Depois desta hora, nao serao aceites projectos sob pretexto algum[15].

Devera ser submetido um ficheiro .lisp contendo o codigo do seu projecto. O ficheiro de codigo deve conter em comentario, na primeira linha, os numeros e os nomes dos alunos do grupo, bem como o numero do grupo. Nao e necessario incluir os ficheiros disponibilizados pelo corpo docente.

4.1.2 | 2.ª Entrega
-------------------

Na segunda entrega do projecto os alunos devem implementar o resto das funcionalidades descritas no enunciado (ver seccao 2.2.2), incluindo as varias variantes dos algoritmos de procura, e as funcoes heuristicas pedidas. Deverao tambem ja nesta fase fazer os testes que permitirao escolher qual a melhor procura/heuristica (embora nao seja necessario incluir os testes no ficheiro de codigo submetido). A entrega da segunda parte sera feita por via electronica atraves do sistema Mooshak, ate as 23:59 do dia 30/11/2014. Depois desta hora, nao serao aceites projectos sob pretexto algum.
Devera ser submetido um ficheiro .lisp contendo o codigo do seu projecto. O ficheiro de codigo deve conter em comentario, na primeira linha, os numeros e os nomes dos alunos do grupo, bem como o numero do grupo. Nao e necessario incluir os ficheiros disponibilizados pelo corpo docente.

4.1.3 | 3.ª Entrega
-------------------

Na terceira entrega, os alunos deverao trabalhar exclusivamente no relatorio do projecto. Nao sera aceite/avaliada qualquer nova entrega de codigo por parte dos alunos. Nao existem excepcoes. O relatorio do projecto devera ser entregue (em .doc ou .pdf) exclusivamente por via electronica no sistema FENIX, ate as 12:00 (meio dia) do dia 9/12/2014.

4.2 | Avaliacao
---------------

As varias entregas têm pesos diferentes no calculo da nota do Projecto. A 1.ª entrega (em codigo) corresponde a 30% da nota final do projecto (ou seja 6 valores). A 2.ª entrega (em codigo) corresponde a 35% da nota final do projecto (ou seja 7 valores). Finalmente a 3.ª entrega, referente ao relatorio, corresponde aos restantes 35% da nota final do projecto (ou seja 7 valores).
A avaliacao da 1.ª entrega sera feita exclusivamente com base na execucao correcta (ou nao) das funcoes pedidas.
A avaliacao da 2.ª entrega tera duas componentes:
  -> A 1.ª componente vale 6 valores e corresponde a avaliacao da correcta execucao das funcoes pedidas e a qualidade do jogador de Tetris. A avaliacao da qualidade do vosso algoritmo e feita usando-o para resolver uma serie de tabuleiros de Tetris com dificuldade incremental, e com um montante de tempo limitado. Sera tida em consideracao a capacidade de retornar uma solucao, bem como a quantidade de pontos obtida para cada tabuleiro.
  -> A 2.ª componente vale 1 valor e corresponde a uma avaliacao manual da qualidade do codigo produzido. Serao analisados factores como comentarios, facilidade de leitura (nomes e indentacao), estilo de programacao e utilizacao de abs. procedimental.

Finalmente, a avaliacao da 3.ª entrega corresponde a avaliacao do relatorio entregue. No template de
relatorio que sera disponibilizado mais tarde, poderao encontrar informacao mais detalhada sobre esta
avaliacao.

4.3 | Condicoes de realizacao
-----------------------------

O codigo desenvolvido deve compilar em CLISP 2.49 sem qualquer “warning” ou erro. Todos os testes efectuados automaticamente, serao realizados com a versao compilada do vosso projecto.
Aconselhamos tambem os alunos a compilarem o codigo para os seus testes de comparacoes entre algoritmos/heuristicas, pois a versao compilada e consideravelmente mais rapida que a versao nao compilada a correr em Common Lisp.
No seu ficheiro de codigo nao devem ser utilizados caracteres acentuados ou qualquer caracter que nao pertenca a tabela ASCII, sob pena de falhar todos os testes automaticos. Isto inclui comentarios e cadeias de caracteres.
É pratica comum a escrita de mensagens para o ecra, quando se esta a implementar e a testar o codigo.
Isto e ainda mais importante quando se estao a testar/comparar os algoritmos. No entanto, nao se esquecam de remover/comentar as mensagens escritas no ecra na versao final do codigo entregue. Se nao o fizerem, correm o risco dos testes automaticos falharem, e irao ter uma ma nota na execucao.
A avaliacao da execucao do codigo do projecto sera feita automaticamente atraves do sistema Mooshak, usando varios testes configurados no sistema. O tempo de execucao de cada teste esta limitado, bem como a memoria utilizada. So podera efectuar uma nova submissao pelo menos 15 minutos depois da submissao anterior. So sao permitidas 10 submissoes em simultaneo no sistema, pelo que uma submissao podera ser recusada se este limite for excedido. Nesse caso tente mais tarde.
Os testes considerados para efeitos de avaliacao podem incluir ou nao os exemplos disponibilizados, alem de um conjunto de testes adicionais. O facto de um projecto completar com sucesso os exemplos fornecidos nao implica, pois, que esse projecto esteja totalmente correcto, pois o conjunto de exemplos fornecido nao e exaustivo. É da responsabilidade de cada grupo garantir que o codigo produzido esta correcto.
Duas semanas antes do prazo da 1.ª entrega (isto e, na Segunda-feira, 27 de Outubro), serao publicadas na pagina da cadeira as instrucoes necessarias para a submissao do codigo no Mooshak. Apenas a partir dessa altura sera possivel a submissao por via electronica. Ate ao prazo de entrega podera efectuar o numero de entregas que desejar, sendo utilizada para efeitos de avaliacao a ultima entrega efectuada.
Deverao portanto verificar cuidadosamente que a ultima entrega realizada corresponde a versao do projecto que pretendem que seja avaliada. Nao serao abertas excepcoes.[16]
Pode ou nao haver uma discussao oral do trabalho e/ou uma demonstracao do funcionamento do programa (sera decidido caso a caso).
Projectos muito semelhantes serao considerados copia e rejeitados. A deteccao de semelhancas entre projectos sera realizada utilizando software especializado17 e cabera exclusivamente ao corpo docente a decisao do que considera ou nao copia. Em caso de copia, todos os alunos envolvidos terao 0 no projecto e serao reprovados na cadeira.

5 | Competicao do Projecto
--------------------------

Vai ser realizada uma competicao entre todos os projectos submetidos para determinar quais os melhores projectos a resolver tabuleiros de Tetris. Para poderem participar na competicao, a vossa implementacao tem que passar todos os testes de execucao referentes as funcoes e tipos de dados definidos neste enunciado. A funcao a ser usada na competicao e a funcao procura-best.
Os 3 melhores classificados na competicao, ou seja os projectos que consigam resolver os tabuleiros com melhor pontuacao serao premiados com as seguintes bonificacoes:
  -> 1.º Lugar – 1,5 valores de bonificacao na nota final do projecto
  -> 2.º Lugar – 1,0 valores de bonificacao na nota final do projecto
  -> 3.º Lugar – 0,5 valores de bonificacao na nota final do projecto
