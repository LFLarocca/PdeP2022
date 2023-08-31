
-- Nombre: Larocca, Lourdes Florencia
-- Legajo: 2037610

-- Parcial Jueves 09 de Junio de 2022
-- Paradigmas de Programación UTN.BA Jueves Mañana

module Library where
import PdePreludat
import qualified GHC.Base as False

parcial = "acá"
--Postres
--A
type Sabor = String
type Peso = Number
type Temperatura = Number

data Postre = UnPostre {
    sabores :: [Sabor],
    peso :: Peso, --en gramos
    temperatura :: Temperatura
} deriving (Show,Eq)

bizcochoborracho :: Postre
bizcochoborracho = UnPostre {sabores = ["fruta", "crema"], peso = 100, temperatura = 25}
medialunalunatica :: Postre
medialunalunatica = UnPostre {sabores = ["ddl", "chocolate"], peso = 10, temperatura = 20}

--B
type Hechizo = Postre -> Postre

incendio :: Hechizo
incendio postre  = cambiarPeso (-5) postre { temperatura = temperatura postre + 1}

cambiarPeso :: Number -> Postre -> Postre
cambiarPeso n postre = postre {peso = peso postre + (n * peso postre / 100)}

immobulus :: Hechizo
immobulus postre = postre { temperatura = 0}

wingardiumLeviosa :: Hechizo
wingardiumLeviosa postre = cambiarPeso (-10) postre { sabores = "concentrado" : sabores postre}

diffinido :: Number -> Hechizo
diffinido porcentaje = cambiarPeso (-porcentaje)

riddikulus :: Sabor -> Hechizo 
riddikulus sabor postre = postre {sabores = reverse sabor : sabores postre}

avadaKedavra :: Hechizo
avadaKedavra postre = immobulus postre {sabores = []}

--C
type ConjPostres = [Postre]

estanListos :: Hechizo -> ConjPostres -> Bool
estanListos hechizo = all (estaListo . hechizo)

estaListo :: Postre -> Bool
estaListo postre | pesoMasCero postre && tieneSabor postre && noCongelado postre = True
                 | otherwise = False

noCongelado :: Postre -> Bool
noCongelado postre = temperatura postre > 0

tieneSabor :: Postre -> Bool
tieneSabor postre = not (null (sabores postre))

pesoMasCero :: Postre -> Bool
pesoMasCero postre = peso postre > 0

--D
pesoPromListos :: ConjPostres -> Number
pesoPromListos postres = sum(map peso (postresListos postres))/ length (postresListos postres)

postresListos :: ConjPostres -> ConjPostres --Me da una lista con los listos
postresListos = filter estaListo

-- Magos
data Mago = UnMago {
    hechizosAprendidos :: [Hechizo],
    cantHorrorcruxes :: Number
}

--A
asisteClasedefensa :: Hechizo -> Postre -> Mago -> Mago 
asisteClasedefensa hechizo postre mago
    | hechizo postre == avadaKedavra postre = mago {hechizosAprendidos = hechizo : hechizosAprendidos mago, cantHorrorcruxes = cantHorrorcruxes mago + 1}
    | otherwise = mago {hechizosAprendidos = hechizo : hechizosAprendidos mago}

--B
cualmejorhechizo :: Postre -> Mago -> Hechizo
cualmejorhechizo postre mago = mejorhechizo postre (hechizosAprendidos mago)

--Si el length de los sabores del postre aplicado al primer hechizo de los aprendidos es mayor al "" del segundo => devuelvo primer hechizo
mejorhechizo :: Postre -> [Hechizo] -> Hechizo
mejorhechizo postre [] = identidad
mejorhechizo postre (x:xs) 
    | length (sabores (x postre)) > length (sabores (head xs postre)) = x -- && mejorhechizo postre xs
    | otherwise = mejorhechizo postre xs
--Comenté la recursividad porque me daba error, de haber tenido mas tiempo, lo hubiese intentado mejorar

identidad :: Hechizo
identidad = id
 
--C
listInfinitaPostres :: ConjPostres
listInfinitaPostres = cycle [bizcochoborracho, medialunalunatica]

listInfinitaHechizos :: [Hechizo]
listInfinitaHechizos = cycle [incendio, immobulus, wingardiumLeviosa]

magoLoco :: Mago
magoLoco = UnMago {hechizosAprendidos = listInfinitaHechizos, cantHorrorcruxes = 2}

{-
--B
Suponiendo que hay una mesa con infinitos postres, y pregunto si algún hechizo los deja listos, consultar 
por una determinada cantidad de ellos (ejemplo: take 10 listaPostresInfinitos) sería una buena forma de 
logar que Haskell pueda arrojar un resultado, ya que solo tomará los primeros 10 elementos de la lista
y podrá evaluarlos en su totalidad. Esto se produce gracias a la utilizacion del lazy evaluation, modo de 
evaluación que haskell utiliza donde sólo se concentra en lo que se pide, y no realiza procedimiento de más.

De lo contrario (si no acotamos la lista), jamás podrá darnos una respuesta, ya que
al analizar si los postres están listos, se evalúan a TODOS en ella. Si tratamos con una lista infinita, esta 
jamás se terminará de evaluar, y no podrá arrojar ni True ni False.

--C
Suponiendo que un mago tiene infinitos hechizos en ningún caso se podría encontrar al mejor hechizo. 
Esto se debe a que "el mejor hechizo" es aquel que deja al postre con más cantidad de sabores luego de usarlo, 
y para poder analizar esto, se deben evaluar los hechizos en su totalidad para luego buscar el que obtenga el valor 
mas alto. Si poseemos una lista infinita de hechizos, nuevamente, acotarla sería la única forma que existe
para analizarla al menos en parte de ella. Si esto no ocurre, la consola seguirá ejecutando la lista indefinidamente
y no recibiremos ningún resultado.
-}