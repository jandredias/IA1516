# IA1516

1| Introducão
-------------

Neste projecto pretende-se implementar um algoritmo de procura capaz de jogar uma variante do jogo Tetris, em que as pecas por colocar são conhecidas a partida. O objectivo e tentar maximizar o numero de pontos com as pecas definidas. Para simplificar o jogo, só e permitido ao jogador escolher a rotacão e a posicão onde a peca ira cair. Uma vez escolhida a rotacão e a posicão, a peca devera cair a direito sem qualquer movimento adicional. 

O tabuleiro do jogo e constituido por 10 colunas e 18 linhas. As linhas estão numeradas de 0 a 17, e as colunas de 0 a 9. Cada posicão do tabuleiro pode estar vazia ou ocupada. Assim que uma peca e colocada sobre o tabuleiro, se existir alguma posicão ocupada na linha 17 o jogo termina. Caso Pecas por colocar contrario, todas as linhas que estejam completas[1] são removidas e o jogador ganha o seguinte numero de pontos em funcão do numero de linhas removidas:

| Linhas | Pontos |
|-----------------|
|     1  | 100    |
|     2  | 300    |
|     3  | 500    |
|     4  | 800    |

Quando uma linha e removida, as linhas superiores a essa linha deverão descer como se vê na figura seguinte.

2| Trabalho a realizar
----------------------

O objectivo do projecto e escrever um programa em Common Lisp, que utilize tecnicas de procura sistematica, para determinar a sequência de accões de modo a conseguir colocar todas as pecas e tentando maximizar o numero de pontos obtidos.
Para tal deverão realizar varias tarefas que vão desde a implementacão dos tipos de dados usados na representacão do tabuleiro, ate a implementacão dos algoritmos de procura e de heuristicas para guiar os algoritmos. Uma vez implementados os algoritmo de procura, os alunos deverão fazer um estudo/analise comparativa das varias versões dos algoritmos, bem como das funcões heuristicas implementadas.
Não e necessario testarem os argumentos recebidos pelas funcões, a não ser que seja indicado explicitamente para o fazerem. Caso não seja dito nada, podem assumir que os argumentos recebidos por uma funcão estão sempre correctos.

2.1 | Tipos Abstractos de Informacão
------------------------------------

2.1.1 | Tipo Accão
------------------

O tipo Accão e utilizado para representar uma accão do jogador. Uma accão e implementada como um par cujo elemento esquerdo e um numero de coluna que indica a coluna mais a esquerda escolhida para a peca cair, e cujo elemento direito corresponde a um array bidimensional com a configuracão geometrica da peca depois de rodada[2]. A figura seguinte mostra o exemplo de uma accão. O ficheiro utils.lisp define todas as configuracões geometricas possiveis para cada peca[3].

 -> cria-accao: inteiro x array -> accao
    Este construtor recebe um inteiro correspondente a posicão da coluna mais a esquerda a partir da qual a peca vai ser colocada, e um array com a configuracão da peca a colocar, e devolve uma nova accão.

  -> accao-coluna: accao -> inteiro
    Este selector devolve um inteiro correspondente a coluna mais a esquerda a partir da qual a
peca vai ser colocada.

  -> accao-peca: accao -> array
    Este selector devolve o array com a configuracão geometrica exacta com que vai ser colocada.

2.1.2 | Tipo tabuleiro
----------------------

O tipo Tabuleiro e utilizado para representar o tabuleiro do jogo de Tetris com 18 linhas e 10 colunas, em que cada posicão do tabuleiro pode estar preenchida ou não. Cabe aos alunos a escolha da representacão mais adequada para este tipo.
  -> cria-tabuleiro: {} -> tabuleiro
    Este construtor não recebe qualquer argumento, e devolve um novo tabuleiro vazio.

  -> copia-tabuleiro: tabuleiro -> tabuleiro
    Este construtor recebe um tabuleiro, e devolve um novo tabuleiro com o mesmo conteudo do tabuleiro recebido. O tabuleiro devolvido deve ser um objecto computacional diferente e devera garantir que qualquer alteracão feita ao tabuleiro original não deve ser repercutida no novo tabuleiro e vice-versa.
  -> tabuleiro-preenchido-p: tabuleiro x inteiro x inteiro -> lógico
    Este selector recebe um tabuleiro, um inteiro correspondente ao numero da linha e um inteiro correspondente ao numero da coluna, e devolve o valor lógico verdade se essa posicão estiver preenchida, e falso caso contrario.
  -> tabuleiro-altura-coluna: tabuleiro x inteiro -> inteiro
    Este selector recebe um tabuleiro, um inteiro correspondente ao numero de uma coluna, e devolve a altura de uma coluna, ou seja a posicão mais alta que esteja preenchida dessa coluna. Uma coluna que não esteja preenchida devera ter altura 0.
  -> tabuleiro-linha-completa-p: tabuleiro x inteiro -> lógico
    Este reconhecedor recebe um tabuleiro, um inteiro correspondente ao numero de uma linha, e devolve o valor lógico verdade se todas as posicões da linha recebida estiverem preenchidas, e falso caso contrario.
  -> tabuleiro-preenche!: tabuleiro x inteiro x inteiro -> {}
    Este modificador recebe um tabuleiro, um inteiro correspondente ao numero linha e um inteiro correspondente ao numero da coluna, e altera o tabuleiro recebido para na posicão correspondente a linha e coluna passar a estar preenchido. Se o numero de linha e de coluna recebidos não forem validos (i.e. não estiverem entre 0 e 17, e 0 e 9), esta funcão não devera fazer nada. O valor devolvido por desta funcão não esta definido[4].
  -> tabuleiro-remove-linha!: tabuleiro x inteiro -> {}
    Este modificador recebe um tabuleiro, um inteiro correspondente ao numero de linha, e altera o tabuleiro recebido removendo essa linha do tabuleiro, e fazendo com que as linhas por cima da linha removida descam uma linha. As linhas que estão por baixo da linha removida não podem ser alteradas. O valor devolvido por desta funcão não esta definido.
  -> tabuleiro-topo-preenchido-p: tabuleiro -> lógico
    Este reconhecedor recebe um tabuleiro, e devolve o valor lógico verdade se existir alguma posicão na linha do topo do tabuleiro (linha 17) que esteja preenchida, e falso caso contrario.
  -> tabuleiros-iguais-p: tabuleiro x tabuleiro -> lógico
    Este teste recebe dois tabuleiros, e devolve o valor lógico verdade se os dois tabuleiros forem iguais (i.e. tiverem o mesmo conteudo), e falso caso contrario.
  -> tabuleiro->array: tabuleiro -> array
    Este transformador de saida recebe um tabuleiro e devolve um novo array com 18 linhas e 10 colunas, que para cada linha e coluna devera conter o valor lógico correspondente a cada posicão do tabuleiro. O array retornado devera garantir que qualquer alteracão feita ao tabuleiro original não deve ser repercutida no novo array e vice-versa.
  -> array->tabuleiro: array -> tabuleiro
    Este transformador de entrada recebe um array com 18 linhas e 10 colunas cujas posicões têm o valor lógico T ou Nil, e constrói um novo tabuleiro com o conteudo do array recebido. O tabuleiro devolvido devera garantir que qualquer alteracão feita ao array original não deve ser repercutida no novo tabuleiro e vice-versa.

2.1.3 | Tipo Estado
-------------------

O tipo estado representa o estado de um jogo de Tetris. Este tipo devera ser implementado obrigatoriamente como uma estrutura[5] em Common Lisp com os seguintes campos:

  -> pontos – o numero de pontos conseguidos ate ao momento no jogo;
  -> pecas-por-colocar – uma lista com as pecas que ainda estão por colocar, pela ordem de
colocacão. As pecas nesta lista são representadas pelo simbolo correspondente a letra da peca, i.e. i,j,l,o,s,z,t[6];
  -> pecas-colocadas – uma lista com as pecas ja colocadas no tabuleiro (representadas tambem
pelo simbolo). Esta lista deve encontrar-se ordenada da peca mais recente para a mais antiga;
  -> Tabuleiro – o tabuleiro com as posicões actualmente preenchidas do jogo.

Para alem das operacões construidas automaticamente para estruturas (ex: selectores e modificadores), devera implementar os seguintes operadores adicionais sobre estados.
  -> copia-estado: estado -> estado
    Este construtor recebe um estado e devolve um novo estado cujo conteudo deve ser copiado a partir do estado original. O estado devolvido devera garantir que qualquer alteracão feita ao estado original não deve ser repercutida no novo estado e vice-versa.
  -> estados-iguais-p: estado x estado -> lógico
    Este teste recebe dois estados, e devolve o valor lógico verdade se os dois estados forem iguais (i.e. tiverem o mesmo conteudo) e falso caso contrario.
  -> estado-final-p: estado -> lógico
    Este reconhecedor recebe um estado e devolve o valor lógico verdade se corresponder a um estado final onde o jogador ja não possa fazer mais jogadas e falso caso contrario. Um estado e considerado final se o tabuleiro tiver atingido o topo ou se ja não existem pecas por colocar.

2.1.4 | Tipo problema
---------------------

O tipo problema representa um problema generico de procura. Este tipo devera ser implementado obrigatoriamente como uma estrutura em Common Lisp com os seguintes campos:
  -> estado-inicial – contem o estado inicial do problema de procura;
  -> solucao – funcão que recebe um estado e devolve T se o estado for uma solucão para o problema de procura, e nil caso contrario;
  -> accoes – funcão que recebe um estado e devolve uma lista com todas as accões que são possiveis fazer nesse estado;
  -> resultado – funcão que dado um estado e uma accão devolve o estado sucessor que resulta de executar a accão recebida no estado recebido;
  -> custo-caminho – funcão que dado um estado devolve o custo do caminho desde o estado inicial ate esse estado.

2.2 | Funcões a implementar
---------------------------

Para alem dos tipos de dados especificados na seccão anterior, e obrigatória tambem a implementacão das seguintes funcões.

2.2.1 | Funcões do problema de procura
--------------------------------------

Estas funcões podem ser usadas como funcões do problema de procura, que depois serão usadas pelos algoritmos de procura:
  -> solucao: estado -> lógico
    Esta funcão recebe um estado, e devolve o valor lógico verdade se o estado recebido corresponder a uma solucão, e falso contrario. Um estado do jogo Tetris e considerado solucão se o topo do tabuleiro não estiver preenchido e se ja não existem pecas por colocar, ou seja, todas as pecas foram colocadas com sucesso (independentemente de terem ou não sido obtidos pontos).
  -> accoes: estado -> lista de accões
    Esta funcão recebe um estado e devolve uma lista de accões correspondendo a todas as accões validas que podem ser feitas com a próxima peca a ser colocada. Uma accão e considerada valida mesmo que faca o jogador perder o jogo (i.e. preencher a linha do topo). Uma accão e invalida se não for fisicamente possivel dentro dos limites laterais do jogo[7][8]. Por exemplo colocar a peca i deitada na ultima coluna do tabuleiro, ou tentar colocar a peca s com a
orientacão inicial na coluna 8[9], tal como se pode ver na imagem seguinte.
Figura 4- Exemplo de accão invalida

A ordem com que são devolvidas as accões na lista e muito importante. À frente da lista devem estar obrigatoriamente as accões correspondentes a orientacão inicial da peca, percorrendo todas as colunas possiveis da esquerda para a direita. Depois e escolhida uma nova orientacão, rodando a peca 90o no sentido horario, e volta-se a gerar para todas as colunas possiveis da esquerda para a direita. No entanto, se ao rodar uma peca obter uma configuracão geometrica
ja explorada anteriormente (como por exemplo no caso da peca O em que todas as rotacões correspondem a mesma configuracão) não devem ser geradas novamente as accões[10].

  -> resultado: estado x accao -> estado
    Esta funcão recebe um estado e uma accão, e devolve um novo estado que resulta de aplicar a accão recebida no estado original. Atencão, o estado original não pode ser alterado em situacão alguma. Esta funcão deve actualizar as listas de pecas, colocar a peca especificada pela accão na posicão correcta do tabuleiro. Depois de colocada a peca, e verificado se o topo do tabuleiro esta preenchido. Se estiver, não se removem linhas e devolve-se o estado. Se não estiver, removem-se as linhas e calculam-se os pontos obtidos.
  -> qualidade: estado -> inteiro
    Os algoritmos de procura informada estão concebidos para tentar minimizar o custo de caminho. No entanto, se quisermos maximizar os pontos obtidos, podemos olhar para isto como um problema de maximizacão de qualidade. Para podermos usar a qualidade com os algoritmos de procura melhor primeiro, uma solucão simples e convertermos a qualidade num valor negativo de custo. Assim sendo, um estado com mais pontos ira ter um valor menor (negativo) e
tera prioridade para o mecanismo de escolha do próximo nó a ser expandido.
Portanto, a funcão qualidade recebe um estado e retorna um valor de qualidade que corresponde ao valor negativo dos pontos ganhos ate ao momento.
  -> custo-oportunidade: estado -> inteiro
    Uma representacão alternativa para um problema de maximizacão de qualidade, e considerar que por cada accão podemos potencialmente ganhar um determinado valor, e que o custo e dado pelo facto de não conseguirmos ter aproveitado ao maximo a oportunidade. Assim sendo o custo de oportunidade pode ser calculado como a diferenca entre o maximo possivel e o efetivamente conseguido. Portanto esta funcão, dado um estado, devolve o custo de oportunidade de todas as accões realizadas ate ao momento, assumindo que e sempre possivel fazer o maximo de pontos por cada peca colocada[11]. Ao usarmos esta funcão como custo, os algoritmos de procura irão tentar minimizar o custo de oportunidade.

2.2.2 | Procuras
----------------

As funcões descritas nesta subseccão correspondem aos algoritmos de procura a implementar para determinar a sequência de accões de modo a colocar todas as pecas.
  
  -> procura-pp: problema -> lista accões 
    Esta funcão recebe um problema e usa a procura em profundidade primeiro em arvore para obter uma solucão para resolver o problema. Devolve uma lista de accões que se executada pela ordem especificada ira levar do estado inicial a um estado objectivo. Deve ser utilizado um criterio de Last In First Out, pelo que o ultimo nó a ser colocado na fronteira devera ser o primeiro a ser explorado a seguir. Devem tambem ter o cuidado do algoritmo ser independente
do problema, ou seja devera funcionar para este problema do Tetris, mas devera funcionar tambem para qualquer outro problema[12] de procura.
  -> procura-A*: problema x heuristica -> lista accões
    Esta funcão recebe um problema e uma funcão heuristica, e utiliza o algoritmo de procura A* em arvore para tentar determinar qual a sequência de accões de modo a maximizar os pontos obtidos. A funcão heuristica corresponde a uma funcão que recebe um estado e devolve um numero, que representa a estimativa do custo/qualidade[13] a partir desse estado ate ao melhor estado objectivo. Em caso de empate entre dois nós com igual valor de f na lista deve ser
escolhido o ultimo a ter sido colocado na fronteira. Devem tambem ter o cuidado do algoritmo ser independente do problema.
  -> procura-best: array x lista pecas -> lista accões
    Esta funcão recebe um array correspondente a um tabuleiro e uma lista de pecas por colocar, inicializa o estado e a estrutura problema com as funcões escolhidas pelo grupo, e ira usar a melhor procura e a melhor heuristica e melhor funcão custo/qualidade feita pelo grupo para obter a sequência de accões de modo a conseguir colocar todas as pecas no tabuleiro com o maximo de pontuacão. No entanto, tenham em consideracão que esta funcão ira ter um limite
de tempo para retornar um resultado, portanto não vos serve de nada retornar a solucão óptima se excederem o tempo especificado[14]. É importante encontrar um compromisso entre a pontuacão obtida e o tempo de execucão do algoritmo. Esta funcão ira ser a funcão usada para avaliar a qualidade da vossa versão final. Se assim o entenderem, nesta funcão ja podem usar implementacões e optimizacões especificas para o jogo do Tetris.
É importante ter em conta, que para alem destas funcões explicitamente definidas (que serão testadas automaticamente), na 2.ª fase do projecto deverão implementar tecnicas adicionais de optimizacão, varias heuristicas, ou ate mesmo funcões de custo alternativas, e testa-las. Cabe aos alunos decidir que tecnicas/heuristicas adicionais irão precisar para que o vosso algoritmo final procura-best seja o melhor possivel.

2.3 | Estudo e analise dos algoritmos e heuristicas implementadas
-----------------------------------------------------------------

Na parte final do projecto, e obrigatório os alunos compararem as diferentes variantes das procuras, algoritmos e heuristicas usadas para resolver o jogo do Tetris especificado, e perceberem as diferencas entre elas. Para isso deverão medir varios factores relevantes, e comparar os algoritmos num conjunto significativo de exemplos. Deverão tambem tentar analisar/justificar o porquê dos resultados obtidos.
Os resultados dos testes efectuados deverão ser usados para escolher as melhores procuras e as melhores funcões de custo/heuristicas a serem usadas. Esta escolha devera ser devidamente justificada no relatório do projecto.
Nesta fase final e tambem pretendido que os alunos escrevam um relatório sobre o projecto realizado.
Para alem dos testes efectuados e da analise correspondente, o relatório do projecto devera conter tambem informacão acerca da implementacão de alguns tipos e funcões. Por exemplo, qual a representacão escolhida para cada tipo (e porquê), qual a funcão de utilidade utilizada, como foram implementas as procuras e que optimizacões foram efectuadas, quais as funcões heuristicas implementadas e como e que foram implementadas, etc. Sera disponibilizado um template do relatório para que os alunos tenham uma ideia melhor do que e necessario incluir no relatório final do projecto.

3 | Ficheiro utils
------------------

Foi fornecido um ficheiro de utilitarios juntamente com o enunciado, que define a configuracão geometrica para cada rotacão possivel de cada peca. Para alem disso, fornece tambem um conjunto de funcões para gerar tabuleiros aleatórios e listas de pecas aleatórias. Mas mais importante, o ficheiro utils fornece uma funcão muito util para visualizar a execucão das jogadas devolvidas pelo vosso algoritmo de procura, e testar assim a qualidade das vossas funcões.
A funcão executa-jogadas recebe um estado inicial e uma lista de accões (a lista devolvida por um algoritmo de procura), e vai desenhando o estado resultante de ir colocar as pecas de acordo com as accões recebidas, mostrando os pontos obtidos. Para avancar entre ecrãs, devera premir a tecla “Enter”.

Figura 5- Exemplo de visualizacão usando a funcão executa-jogadas

4 | Entregas, Prazos, Avaliacão e Condicões de Realizacão
---------------------------------------------------------

4.1 | Entregas e Prazos
-----------------------

A realizacão do projecto divide-se em 3 entregas. As duas primeiras entregas correspondem a implementacão do código do projecto, enquanto que a 3.ª entrega corresponde a entrega do relatório do projecto. 

4.1.1 | 1.ª Entrega
-----------------

Na primeira entrega pretende-se que os alunos implementem os tipos de dados descritos no enunciado (seccão 2.1) bem como as funcões correspondentes a seccão 2.2.1. A entrega desta primeira parte sera feita por via electrónica atraves do sistema Mooshak, ate as 23:59 do dia 09/11/2014. Depois desta hora, não serão aceites projectos sob pretexto algum[15].

Devera ser submetido um ficheiro .lisp contendo o código do seu projecto. O ficheiro de código deve conter em comentario, na primeira linha, os numeros e os nomes dos alunos do grupo, bem como o numero do grupo. Não e necessario incluir os ficheiros disponibilizados pelo corpo docente.

4.1.2 | 2.ª Entrega
-------------------

Na segunda entrega do projecto os alunos devem implementar o resto das funcionalidades descritas no enunciado (ver seccão 2.2.2), incluindo as varias variantes dos algoritmos de procura, e as funcões heuristicas pedidas. Deverão tambem ja nesta fase fazer os testes que permitirão escolher qual a melhor procura/heuristica (embora não seja necessario incluir os testes no ficheiro de código submetido). A entrega da segunda parte sera feita por via electrónica atraves do sistema Mooshak, ate as 23:59 do dia 30/11/2014. Depois desta hora, não serão aceites projectos sob pretexto algum.
Devera ser submetido um ficheiro .lisp contendo o código do seu projecto. O ficheiro de código deve conter em comentario, na primeira linha, os numeros e os nomes dos alunos do grupo, bem como o numero do grupo. Não e necessario incluir os ficheiros disponibilizados pelo corpo docente.

4.1.3 | 3.ª Entrega
-------------------

Na terceira entrega, os alunos deverão trabalhar exclusivamente no relatório do projecto. Não sera aceite/avaliada qualquer nova entrega de código por parte dos alunos. Não existem excepcões. O relatório do projecto devera ser entregue (em .doc ou .pdf) exclusivamente por via electrónica no sistema FENIX, ate as 12:00 (meio dia) do dia 9/12/2014.

4.2 | Avaliacão
---------------

As varias entregas têm pesos diferentes no calculo da nota do Projecto. A 1.ª entrega (em código) corresponde a 30% da nota final do projecto (ou seja 6 valores). A 2.ª entrega (em código) corresponde a 35% da nota final do projecto (ou seja 7 valores). Finalmente a 3.ª entrega, referente ao relatório, corresponde aos restantes 35% da nota final do projecto (ou seja 7 valores).
A avaliacão da 1.ª entrega sera feita exclusivamente com base na execucão correcta (ou não) das funcões pedidas.
A avaliacão da 2.ª entrega tera duas componentes:
  -> A 1.ª componente vale 6 valores e corresponde a avaliacão da correcta execucão das funcões pedidas e a qualidade do jogador de Tetris. A avaliacão da qualidade do vosso algoritmo e feita usando-o para resolver uma serie de tabuleiros de Tetris com dificuldade incremental, e com um montante de tempo limitado. Sera tida em consideracão a capacidade de retornar uma solucão, bem como a quantidade de pontos obtida para cada tabuleiro.
  -> A 2.ª componente vale 1 valor e corresponde a uma avaliacão manual da qualidade do código produzido. Serão analisados factores como comentarios, facilidade de leitura (nomes e indentacão), estilo de programacão e utilizacão de abs. procedimental.

Finalmente, a avaliacão da 3.ª entrega corresponde a avaliacão do relatório entregue. No template de
relatório que sera disponibilizado mais tarde, poderão encontrar informacão mais detalhada sobre esta
avaliacão.

4.3 | Condicões de realizacão
-----------------------------

O código desenvolvido deve compilar em CLISP 2.49 sem qualquer “warning” ou erro. Todos os testes efectuados automaticamente, serão realizados com a versão compilada do vosso projecto.
Aconselhamos tambem os alunos a compilarem o código para os seus testes de comparacões entre algoritmos/heuristicas, pois a versão compilada e consideravelmente mais rapida que a versão não compilada a correr em Common Lisp.
No seu ficheiro de código não devem ser utilizados caracteres acentuados ou qualquer caracter que não pertenca a tabela ASCII, sob pena de falhar todos os testes automaticos. Isto inclui comentarios e cadeias de caracteres.
É pratica comum a escrita de mensagens para o ecrã, quando se esta a implementar e a testar o código.
Isto e ainda mais importante quando se estão a testar/comparar os algoritmos. No entanto, não se esquecam de remover/comentar as mensagens escritas no ecrã na versão final do código entregue. Se não o fizerem, correm o risco dos testes automaticos falharem, e irão ter uma ma nota na execucão.
A avaliacão da execucão do código do projecto sera feita automaticamente atraves do sistema Mooshak, usando varios testes configurados no sistema. O tempo de execucão de cada teste esta limitado, bem como a memória utilizada. Só podera efectuar uma nova submissão pelo menos 15 minutos depois da submissão anterior. Só são permitidas 10 submissões em simultaneo no sistema, pelo que uma submissão podera ser recusada se este limite for excedido. Nesse caso tente mais tarde.
Os testes considerados para efeitos de avaliacão podem incluir ou não os exemplos disponibilizados, alem de um conjunto de testes adicionais. O facto de um projecto completar com sucesso os exemplos fornecidos não implica, pois, que esse projecto esteja totalmente correcto, pois o conjunto de exemplos fornecido não e exaustivo. É da responsabilidade de cada grupo garantir que o código produzido esta correcto.
Duas semanas antes do prazo da 1.ª entrega (isto e, na Segunda-feira, 27 de Outubro), serão publicadas na pagina da cadeira as instrucões necessarias para a submissão do código no Mooshak. Apenas a partir dessa altura sera possivel a submissão por via electrónica. Ate ao prazo de entrega podera efectuar o numero de entregas que desejar, sendo utilizada para efeitos de avaliacão a ultima entrega efectuada.
Deverão portanto verificar cuidadosamente que a ultima entrega realizada corresponde a versão do projecto que pretendem que seja avaliada. Não serão abertas excepcões.[16]
Pode ou não haver uma discussão oral do trabalho e/ou uma demonstracão do funcionamento do programa (sera decidido caso a caso).
Projectos muito semelhantes serão considerados cópia e rejeitados. A deteccão de semelhancas entre projectos sera realizada utilizando software especializado17 e cabera exclusivamente ao corpo docente a decisão do que considera ou não cópia. Em caso de cópia, todos os alunos envolvidos terão 0 no projecto e serão reprovados na cadeira.

5 | Competicão do Projecto
--------------------------

Vai ser realizada uma competicão entre todos os projectos submetidos para determinar quais os melhores projectos a resolver tabuleiros de Tetris. Para poderem participar na competicão, a vossa implementacão tem que passar todos os testes de execucão referentes as funcões e tipos de dados definidos neste enunciado. A funcão a ser usada na competicão e a funcão procura-best.
Os 3 melhores classificados na competicão, ou seja os projectos que consigam resolver os tabuleiros com melhor pontuacão serão premiados com as seguintes bonificacões:
  -> 1.º Lugar – 1,5 valores de bonificacão na nota final do projecto
  -> 2.º Lugar – 1,0 valores de bonificacão na nota final do projecto
  -> 3.º Lugar – 0,5 valores de bonificacão na nota final do projecto
