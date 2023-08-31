/** 
Apellido y nombre: Lourdes Florencia Larocca
Nro de Legajo: 2037610
*/
 
 //-------------------------------------------------
 //PLATOS
 //-------------------------------------------------
 
 class Plato {
 	var property azucar
 	
 	method esBonito()
 	
 	method cantCalorias() { //PUNTO 1
 		return (3 * azucar + 100)
 	}
 	
 	method catar(catador){ return catador.catar(self)} //PUNTO 2
 	
 }
 
 class Entrada inherits Plato(azucar = 0) {
 	override method esBonito() = true
 }
 
 class Principal inherits Plato{
 	var bonito
 	
 	override method esBonito() = bonito //Depende de cada caso
 }
 
 class Postre inherits Plato(azucar = 120) {
 	var cantColores
 	
 	override method esBonito(){
 		return (cantColores > 3)
 	}
 }
 
 //-------------------------------------------------
 //COCINEROS
 //-------------------------------------------------
 
 class Cocinero {
 	var property nivelDulzorDeseado = 0 //la iniciarán los panaderos
 	var property caloriasPermitidas = 0 //la iniciarán los chefs
 	var especialidad
 	
 	method cambiarEspecialidad(nuevaEspecialidad) { //PUNTO 3
 		especialidad = nuevaEspecialidad
 	}
 	
 	method sabeCocinar() = true
 	
 	method catar(plato){ //PUNTO 2
 		return (self.calificar(plato))
 	}
 	
 	method calificar(plato){
 		return (especialidad.calificar(plato, self))
 	}
 	
 	method cocina(){//PUNTO 5
 		especialidad.cocina(self)
 	} 
 	
 	method participar(torneo){ //PUNTO 6
 		const platoAPresentar = especialidad.cocina()
 		torneo.presentar(self, platoAPresentar)
 	}
 	
 }
 
object pastelero {
 	
 	method calificar(plato, cocinero){
 		return (5 * plato.azucar() / cocinero.nivelDulzorDeseado()).min(10)
 	}
 	
	method cocina(cocinero){ //PUNTO 5
 		const coloresAContener = cocinero.nivelDulzorDeseado() / 50
 		return ([new Postre(cantColores = coloresAContener)])
 	}
 }
 
 class Chef { //Tmb es una especialidad
 	
 	method calificar(plato, cocinero) {
 		if(self.loConsideraPerfecto(plato, cocinero)) return 10
 		else return self.calificacionAlternativa(plato)
 	}
 	
 	method calificacionAlternativa(plato) = 0
 	
 	method loConsideraPerfecto(plato, cocinero) {
 		return (plato.esBonito() && plato.cantCalorias()> cocinero.caloriasPermitidas())
 	}
 	
 	method cocina(cocinero) {
 		const azucarAContener = cocinero.caloriasPermitidas()
 		return ([new Principal(bonito = true, azucar = azucarAContener)])
 	}
 }
 
 object souschef inherits Chef { //PUNTO 4
 	override method calificacionAlternativa(plato){
 		return (plato.cantCalorias()/100).min(6)
 	}
 	
 	override method cocina(cocinero) {
 		return ([new Entrada()])
 	}
 }
 
 //-------------------------------------------------
 //TORNEOS
 //-------------------------------------------------
 
 class Torneos { //PUNTO 6
 	var catadores =[] //Tmb son cocineros, se añadirán cuando se comience el torneo
 	var calificacionPlatosCompitiendo = []
 	var participantes = []
 	var ganador = [] //Lo inicio como lista vacía pq sino pedirá que se inicialice junto al torneo
 	 	
 	method presentar(cocinero, plato){
 		participantes.add(cocinero)
 		var calificacionDelPlato = (catadores.map({catador => catador.catar(plato)})).sum()
 		if(calificacionPlatosCompitiendo.all({calificacionPlato => calificacionPlato < calificacionDelPlato})){
 			ganador = cocinero
 		}
 		calificacionPlatosCompitiendo.add(calificacionDelPlato)
 	}
 	
 	method cocineroGanador() = ganador
 	
 	method ganador() {
 		if (participantes.isEmpty()){
 			throw new Exception (message = "No se presentó nadie al torneo")
 		} else {
 			return (self.cocineroGanador())
 		}
 	}
 	
 }
 
 
 
 
 
 
 
 
 
 
 
 
 
 