# Jogo Genius

Jogo Genius escrito em VHDL. Pode ser executado tanto em emuladores de placa FPGA (fpgaemu.sites.ufsc.br),
quanto na própria placa a partir do programa Quartus.

• Para iniciar o jogo o usuário ativa a entrada de reset, SW(1), e passamos ao estado START onde são activados os
  comandos de reset (R1 e R2). Nesse estado os displays HEX5 e HEX4 mostrarão a letra L de level e o nível de jogo,
  respectivamente, os displays HEX3 e HEX2 mostrarão a letra t de time e o tempo máximo de jogo, respectivamente,
  e por último, os displays HEX1 e HEX0 mostrarão a letra r de round e o valor da rodada do jogo, respectivamente.
  O nível de jogo, tempo máximo de jogo e rodada serão explicados a seguir. Do estado START passamos diretamente
  ao estado SETUP.

• Uma vez no estado SETUP o usuário deve escolher uma das quatro velocidades iniciais de jogo com os Switches 9
  e 8, SW(9..8), uma das quatro sequencias de jogo possíveis com os Switches 7 e 6, SW(7..6), e o número máximo
  de iterações por sequencia com os Switches 5 e 2, SW(5..2). As frequências iniciais de jogo serão 0, 5Hz, 1Hz, 2Hz
  e 3Hz. O nível de jogo será mostrado no HEX4. Damos inicio ao jogo ativando a entrada enter SW(0) e passando
  ao estado Play_FPGA.

• Uma vez no estado PLAY_FPGA é ativada a sequencia seleccionada a qual será mostrada nos LEDR(3..0). Dita
  sequencia possui 16 linhas de atribuição de 4-bits e um exemplo de sequencia decSeq00.vhd está disponível na
  pasta de projeto no Moodle da disciplina. Corre a cargo do aluno fazer as outras três sequências à sua escolha. É
  importante destacar que a sequencia pode ter apenas um ”1” lógico por linha e que a sequencia tem estar variando
  continuamente. Na primeira rodada será apresentada uma linha da sequencia, na segunda rodada serão apresentadas
  duas e assim sucessivamente. A cada rodada, a frequência da sequência apresentada será incrementada em 0,2Hz.
  Uma vez terminada a sequência, o jogo passa para o próximo estado, PLAY_USER, quando esteja ativo um sinal
  de status, chamado end_FPGA.

• Uma vez no estado PLAY_USER o usuário deve indicar com os botões de pressão KEY(3..0) a sequencia mostrada
  no estado anterior. A sequência replicada será apresentada nos LEDG(3..0) na DE2, caso seja testado no emulador
  on-line, devera ser usado os LEDR(17..14). Neste estado, o displays HEX2 mostrará uma contagem ascendente de
  0 a 9 com frequência de 1Hz. Se o tempo acaba é ativado um sinal de status end_time e o jogo passa ao estado
  RESULT, se não terminou o tempo e o usuário introduz a sequencia que achar correta então se ativa um sinal de
  status end_user, o jogo passa ao estado CHECK.

• No estado CHECK se avalia se o usuário errou na replicação da sequência. Se o usuário replicou a sequência
  corretamente, um sinal de status match está ativo e o jogo passa ao estado NEXT_ROUND. Se o usuário errou
  passa ao estado RESULT. Nesse estado habilitamos um comando para contar a rodada, que é mostrada no HEX0.

• No estado NEXT_ROUND se avalia um sinal de status win que indica se o jogo chegou ao último valor da
  sequência. Se chegou então win está ativo e o jogo passa ao estado RESULT caso contrario passa ao estado
  PLAY_FPGA. Neste estado serão resetadas as contagens das sequências das FPGA e o usuário.

• No estado RESULT será mostrado a pontuação final em Hexadecimal nos displays HEX1 e HEX0. Para o nível
  de jogo j, uma sequência i (selecionados com os SW(9..6)) e o resultado das rodadas, a pontuação final será
  64 × j + 4 × rodadas + i. Corre a cargo do aluno implementar a dita operação com a menor lógica possível. Nesse
  estado os displays HEX5, HEX4, HEX3, HEX2 mostrarão FPgA ou USEr indicando quem ganhou o jogo e no
  LEDR(4) o status win. Nesse estado o usuário deverá pressionar reset para passar a START e reiniciar o jogo.

Projeto final da matéria Circuitos e Técnicas Digitais (EEL5105-01208B) pela UFSC.
