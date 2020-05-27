# Projecto - AC 2019/20

• João Nunes 96745                     
• Francisco Paiva 96737                   
• Gonçalo Costa 92881

## 1. Introdução

Este projeto consiste no desenvolvimento de um jogo em linguagem assembly recorrendo a rotinas e interrupções.

O principal objetivo do jogo é mover uma nave espacial e fazer com que esta dispare balas tentando acertar e, consequentemente, destruir o maior número de naves espaciais inimigas.

Estas naves inimigas estão em constante movimento e podem vir aleatoriamente de três lados, do canto superior esquerdo, do topo do ecrã e do canto superior direito. 

Relativamente à pontuação do jogo, esta é demostrada num display de 3 segmentos. Sempre que o jogador destrói uma nave inimiga ganha 5 pontos. Se as naves inimigas chegarem ao fim do ecrã o jogador perde 10 pontos.

Se o a pontuação do jogador for menor do que zero (i.e., se estando com 0 pontos, ou com 5, uma nave chegar ao fundo do ecrã) o jogo acaba. Além disso, se se a nave colidir com qualquer uma das naves inimiga o jogo acaba. 

## 2. Estrutura geral

Para a conceção deste projeto utilizou-se o processador microprocessador PEPE-16. 

| Tecla | Acção |
|:---:|:---|
| __0__ | Iniciar jogo. |
| __1__ | Terminar jogo. |
| __2__ | Pausar jogo. |
| __5__ | Movimentar para cima e para esquerda. |
| __6__ | Movimentar para cima. |
| __7__ | Movimentar para cima e para direita. |
| __9__ | Movimentar para esquerda. |
| __A__ | Disparar bala. |
| __B__ | Movimentar para direita.
| __D__ | Movimentar para baixo e para esquerda. |
| __E__ | Movimentar para baixo. |
| __F__ | Movimentar para baixo e para direita. |

 
