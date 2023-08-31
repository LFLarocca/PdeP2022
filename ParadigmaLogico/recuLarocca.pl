/* BASE DE CONOCIMIENTO DADA */

 %resultado(UnPais, GolesDeUnPais, OtroPais, GolesDeOtroPais).
resultado(paises_bajos, 3, estados_unidos, 1). % Paises bajos 3 - 1 Estados unidos
resultado(australia, 1, argentina, 2). % Australia 1 - 2 Argentina
resultado(polonia, 3, francia, 1).
resultado(inglaterra, 3, senegal, 0).

pronostico(juan, gano(paises_bajos, estados_unidos, 3, 1)).
pronostico(juan, gano(argentina, australia, 3, 0)).
pronostico(juan, empataron(inglaterra, senegal, 0)).
pronostico(gus, gano(estados_unidos, paises_bajos, 1, 0)).
pronostico(gus, gano(japon, croacia, 2, 0)).
pronostico(lucas, gano(paises_bajos, estados_unidos, 3, 1)).
pronostico(lucas, gano(argentina, australia, 2, 0)).
pronostico(lucas, gano(croacia, japon, 1, 0)).

/* PUNTO 1 */
% a)
jugaron(Pais1, Pais2, DiferenciaDeGoles):-
    resultado(Pais1, Puntos1, Pais2, Puntos2),
    DiferenciaDeGoles is Puntos1 - Puntos2.

jugaron(Pais1, Pais2, DiferenciaDeGoles):- 
    resultado(Pais2, Puntos2, Pais1, Puntos1),
    DiferenciaDeGoles is Puntos2 - Puntos1.

% b)
% Es verdadero si el primer país ingresado primero le gana al segundo
gano(Pais1, Pais2):-
    resultado(Pais1, Puntos1, Pais2, Puntos2),
    Puntos1 > Puntos2.

gano(Pais1, Pais2):- 
    resultado(Pais2, Puntos2, Pais1, Puntos1),
    Puntos1 > Puntos2.

/* PUNTO 2 */
% gano(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor).
% empataron(UnPais, OtroPais, GolesDeCualquieraDeLosDos).

asiertoDeGoles(PaisGanador, GolesGanador, PaisPerdedor, GolesPerdedor):-
    resultado(PaisGanador, GolesGanador, PaisPerdedor, GolesPerdedor).

asiertoDeGoles(PaisGanador, GolesGanador, PaisPerdedor, GolesPerdedor):-
    resultado(PaisPerdedor, GolesPerdedor, PaisGanador, GolesGanador).

asiertoDeGoles(UnPais, GolesDeCualquieraDeLosDos, OtroPais):-
    resultado(UnPais, GolesDeCualquieraDeLosDos, OtroPais, _).

asiertoDeGoles(UnPais, GolesDeCualquieraDeLosDos, OtroPais):-
    resultado(OtroPais, GolesDeCualquieraDeLosDos, UnPais, _).

hanEmpatado(UnPais, OtroPais):-
    resultado(UnPais, Puntos1, OtroPais, Puntos2),
    Puntos1 = Puntos2.

hanEmpatado(UnPais, OtroPais):-
    resultado(OtroPais, Puntos1, UnPais, Puntos2),
    Puntos1 = Puntos2.

% Puntos es 200 si (le pego al ganador y asertó goles) o (empate y asertó goles).
puntosPronostico(gano(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor), 200):-
    gano(PaisGanador, PaisPerdedor),
    asiertoDeGoles(PaisGanador, GolesGanador, PaisPerdedor, GolesPerdedor).

puntosPronostico(empataron(UnPais, OtroPais, GolesDeCualquieraDeLosDos), 200):-
    hanEmpatado(UnPais, OtroPais),
    asiertoDeGoles(UnPais, GolesDeCualquieraDeLosDos, OtroPais).

% Puntos es 100 si (le pego al ganador pero no a la cant de goles) o (empate pero no a la cant de goles)
puntosPronostico(gano(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor), 100):-
    gano(PaisGanador, PaisPerdedor),
    not(asiertoDeGoles(PaisGanador, GolesGanador, PaisPerdedor, GolesPerdedor)).

puntosPronostico(empataron(UnPais, OtroPais, GolesDeCualquieraDeLosDos), 100):-
    hanEmpatado(UnPais, OtroPais),
    not(asiertoDeGoles(UnPais, GolesDeCualquieraDeLosDos, OtroPais)).

% Puntos es 0 si (no le pego al ganador) o (no le pego al empate).
puntosPronostico(gano(PaisGanador, PaisPerdedor, _, _), 0):-
    not(gano(PaisGanador, PaisPerdedor)).

puntosPronostico(empataron(UnPais, OtroPais, _), 0):-
    not(hanEmpatado(UnPais, OtroPais)).

/* PUNTO 3 */
jugaron(PaisGanador, PaisPerdedor):-
    resultado(PaisGanador, _, PaisPerdedor, _).

jugaron(PaisGanador, PaisPerdedor):-
    resultado(PaisPerdedor, _, PaisGanador, _).

esPronosticoJugado(gano(PaisGanador, PaisPerdedor, _, _)):-
    jugaron(PaisGanador, PaisPerdedor).

esPronosticoJugado(empataron(UnPais, OtroPais, _)):-
    jugaron(UnPais, OtroPais).

invicto(Jugador):-
    pronostico(Jugador, _),
    forall((pronostico(Jugador, Pronostico), esPronosticoJugado(Pronostico)), (puntosPronostico(Pronostico, Puntos), Puntos > 1)).

/* PUNTO 4 */
puntaje(Jugador, Puntaje):-
    pronostico(Jugador, _),
    findall(Puntos, (pronostico(Jugador, Pronostico), esPronosticoJugado(Pronostico), puntosPronostico(Pronostico, Puntos)), ListaDePuntos),
    sum_list(ListaDePuntos, Puntaje).
    
/* PUNTO 5 */
esGanador(gano(Pais, _, _, _), Pais).

ganoPorGoleada(PuntosFav, Puntos):-
    PuntosFav > Puntos,
    abs(PuntosFav - Puntos, Puntazos), 
    Puntazos > 3. %La diferencia es de al menos 3 puntos.

% Todos los pronosticos lo ponen como ganador
favorito(Pais):-
    forall(pronostico(_, Pronostico), esGanador(Pronostico, Pais)).

% Gano por goleada todos los partidos que jugó (al menos 3 goles de diferencia)
favorito(Pais):-
    forall((resultado(Pais, PuntosFav, OtroPais, Puntos), Pais \= OtroPais), ganoPorGoleada(PuntosFav, Puntos)).

favorito(Pais):-
    forall((resultado(OtroPais, Puntos, Pais, PuntosFav), Pais \= OtroPais), ganoPorGoleada(PuntosFav, Puntos)).







