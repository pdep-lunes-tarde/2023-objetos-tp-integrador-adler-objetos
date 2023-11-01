import wollok.game.*

import global.*
import vectores.*
import colisiones.*

// valores iniciales (por si queremos definirlos al momento de crear una instancia de la clase)
// x0, y0, doCollision 
class GameObject {
	
	const property x0 = registry.get("centro").x() - self.width()/2
	const property y0 = registry.get("centro").y() - self.height()/2
	var property x = x0 	// posicion actual (para hacer cálculos)
	var property y = y0
	
	var property doCollision = true

	// "position" es lo que le importa a wollok game,
	// por ende usamos "position" nomás para efectuar el cambio de posición. 
	// Utilizamos un vector mutable que entiende mensajes "x()" e "y()".
	var property position = new Vector(x=x0, y=y0) 				// posicion actual (para efectuar cambios)
	
	method height() = 40/registry.get("casillas_pixeles")		// tamaño en pixeles de la imagen utilizada divido por el tamaño de pixel de una casilla
	method width() = 40/registry.get("casillas_pixeles")		// se puede observar la dimensión de la imágen en el .png
	method centro() = self.position() + vector.at(self.width()/2, self.height()/2)
	method image() = "assets/null.png"
	
	override method initialize() {
		super()
		game.addVisual(self) 									// se muestra automáticamente en pantalla al crearse una instancia de la clase
		if (doCollision) {
			colisiones.conjuntoObjetos().add(self)
		}
	}

	method eliminar() {
		updater.remove(self)									// dejamos de actualizarlo
		game.removeVisual(self)									// dejamos de mostrarlo en el juego
		colisiones.conjuntoObjetos().remove(self)				// dejamos de checkear sus colisiones
	}
	
	method doCollision(_state) { 
		doCollision = _state
		if (_state) {
			colisiones.conjuntoObjetos().add(self)
		}
		else {
			colisiones.conjuntoObjetos().remove(self)
		}
	}
	method toggleCollision() { // permite togglear las colisiones del gameObject
		self.doCollision(not doCollision)
	}
	
	method resolverColisionCon(objeto, vectorCorreccion) {
		game.say(self, "Choque con "+objeto.toString())
//		const vel_x = x - old_x 
//		const vel_y = y - old_y
		x += vectorCorreccion.x()
		y += vectorCorreccion.y()	
//		old_x = x + vel_x	
//		old_y = y + vel_y		
	}
}


class UpdatableObject inherits GameObject {
	override method initialize() {
		super()
		updater.add(self) 	// se agrega al updater al crearse una instancia de la clase
	}
	method update() 
}

// valor inicial: x0, y0
class Sangre inherits GameObject {
	override method image() = "assets/PACMAN/sangre3.png" 
	
	override method initialize() {
		super()
		game.schedule(3000, {game.removeVisual(self)}) 	// se elimina dsp de un rato
	}
}

// se deben dar valores a vel_x0, vel_y0.
class VerletObject inherits UpdatableObject {	
	/* Basado en: https://www.youtube.com/watch?v=lS_qeBy3aQI
	 * 			  https://www.youtube.com/watch?v=-GWTDhOQU6M 
	 * */  
	
	/* usamos variable propias x e y, hace los cálculos muchisimo 
	 * más rápido que los Vectores (ya lo probé, rip performance), 
	 * ¿¿¿¿con otros tipos de pares ordenados funcionará???? 
	 * */
	const vel_x0 = 0
	const vel_y0 = 0
	 
	var property old_x = x0 - vel_x0 		// posicion anterior
	var property old_y = y0 - vel_y0

	var property acc_x = 0 	 				// aceleración
	var property acc_y = 0
	
	const hayFriccion = true
	const masa = 1
	
	const g = 0.98
	
	override method initialize() {
		super()

	}
	
	method reiniciar() {
		x = x0 					
		y = y0
		old_x = x0  	
		old_y = y0 
		acc_x = 0 	 				
		acc_y = 0
	}
	
	method tp(_x, _y) {  					// cambia su posicion pero conserva la velocidad que tenía
		const vel_x = x - old_x
		const vel_y = y - old_y
		
		x = _x
		y = _x
		old_x = x - vel_x
		old_y = y - vel_y
	}
	
	method morir() {
		console.println("Rip.")
		const s = new Sangre(x0=x, y0=y, doCollision=false)
//		self.eliminar()
	}
	
	method accelerate(_acc_x, _acc_y) {
		acc_x += _acc_x
		acc_y += _acc_y
	}
	method accelerate(_vector) {
		acc_x += _vector.x()
		acc_y += _vector.y()
	}
	
	method rapidez() {
		const vel_x = x - old_x
		const vel_y = y - old_y
		return (vel_x*vel_x+vel_y*vel_y).squareRoot()
	}
	
	method estaEnRapidezLetal(ejeDeChoque) { // si la magnitud de su velocidad es letal en caso de encontrarse con una pared
		const vel_x = x - old_x
		const vel_y = y - old_y
		
		// NO SÉ SI TIENE SIQUIERA SENTIDO ESTO QUE PLANTEO PERO SUENA PIOLA 
		
		// rapidez_efectiva es la magnitud de la velocidad perpendicular al plano de choque, 
		// osea que es la componente de la velocidad que es paralela al eje de choque,
		// rapidez_efectiva es la rapidez que realmente nos importa para calcular la energia del choque.
		const rapidez_efectiva = vector.at(vel_x, vel_y).escalarProyeccionSobre(ejeDeChoque) 
//		const rapidez_efectiva = vector.at(vel_x, vel_y).modulo()
		const energiaChoque = (masa * rapidez_efectiva*rapidez_efectiva)/2
		if (energiaChoque > 20) {
			console.println(self.toString()+": Energia = "+ energiaChoque.toString())
		}	
		return energiaChoque > 60
	}
	
	method updatePosition(dt) {
		// el valor corresponde al numero de ticks definido en el game.onTick()
		// si los ticks del updater son mayores al valor del dt, entocnes se va a ver en cámara lenta
		
		// calculamos la velocidad con las posiciones actual y anterior
		const vel_x = x - old_x  
		const vel_y = y - old_y
		
		// guardamos las posiciones actuales 
		old_x = x
		old_y = y
			
		// calculamos la nueva posicion con Integración de Verlet (agregue 0.95 para simular friccion)
		if (hayFriccion) {
			x += vel_x * 0.9 + acc_x *dt*dt 
			y += vel_y * 0.9 + acc_y *dt*dt
		} 
		else {
			x += vel_x + acc_x *dt*dt 
			y += vel_y + acc_y *dt*dt
		}
		
		// reiniciamos el valor de la aceleracion
		acc_x = 0
		acc_y = 0 
		
		// aplicamos cambios en wollok game
		position.xy(x, y)
	}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
	
	method applyCircleConstraint(coord_centro, radio) { // trampa circular invisible
		const ejeDeChoque = coord_centro - (vector.at(x, y) + vector.at(4.5,4.5))
		const dist = ejeDeChoque.magnitud()
		
		const coef_perdida_energia = 0.05
		
		if (dist > radio) {  // si se sale del circulo, entonces...
			const diff = dist - radio
			const moverHacia = ejeDeChoque.versor() * diff
		
//			if (self.estaEnRapidezLetal(ejeDeChoque)) {
//				self.morir()
//			}
			/* A GRANDES VELOCIDADES, SE BUGGEA, SOLUCIONES:
			 * - Limitar las velocidades
			 * - Hacer substeps.
			 * - Implementar Continious collision detection.
			 * - Hacer que rebote, reduce las ocurrencias de bug, aunque a veces sigue pasando. 
			 * */
			
			x += moverHacia.x()
			y += moverHacia.y()  
//			const vel_x = x - old_x 
//			const vel_y = y - old_y
//			old_x = x + vel_x * (1-coef_perdida_energia) 
//			old_y = y + vel_y * (1-coef_perdida_energia) 
		}
	}
	
	method applyWallConstraint() {
		const piso = 0
		const techo = registry.get("grid_height") - self.height() // hay q tener en cuenta el tamaño del sprite,
		const derecha = registry.get("grid_width") - self.width() // ya que el pivot está en la esquina abajo-izquierda del sprite.
		const izquierda = 0
		
		const coef_perdida_energia = 0.05
		
		const vel_x = (x - old_x) * (1-coef_perdida_energia) 
		const vel_y = (y - old_y) * (1-coef_perdida_energia)
		
		if (y < piso) {	 								// cuando encuentra el piso
			y = piso
			old_y = y + vel_y				
		}
		if (x < izquierda) { 
			x = izquierda
			old_x = x + vel_x
		}
		if (y > techo) { 								// cuando encuentra el techo
			y = techo
			old_y = y + vel_y
		}									
		if (x > derecha) {					
			x = derecha
			old_x = x + vel_x
		}
		
	}
	method applyGravity() {
		self.accelerate(0,-g)
	}

	method update() {
		const dt = 1
		const substep = 2 // hacemos substeps para mejores físicas. poner en 1 para deshabilitarlo
		const sub_dt = dt / substep
		substep.times { i =>
//			self.applyGravity()
//			self.applyWallConstraint()
			self.applyCircleConstraint(registry.get("centro"), 65)
			self.updatePosition(sub_dt) 
			
		}
	}
}

//orientaciones
object derecha {
	override method toString() = "der"
}
object izquierda {
	override method toString() = "izq"
}
object arriba {
	override method toString() = "arriba"
}
object abajo {
	override method toString() = "abajo"
}
//estados
object cerrado {
	override method toString() = "cerrado"
}
object medio {
	override method toString() = "medio"
}
object abierto {
	override method toString() = "abierto"
	
}


// 

object pacmanFrames {
	const secuenciaEstados = [cerrado, medio, abierto, medio]
	var property orientacion = derecha
	
	var i = 0
	
	method actual() {
		const estadoActual = secuenciaEstados.get(i)
		return "assets/PACMAN/"+estadoActual+"-"+orientacion+".png"
	}
	method avanzar() {
		i++
		if (i==4) {i=0}
	}
	method orientacion(_orientacion) {
		orientacion = _orientacion
	}
}

class Pacman inherits VerletObject {
	const property fuerza = 5
	const property radio = self.width()/2
	
	override method image() = pacmanFrames.actual()
	
	override method initialize() {
		super()		
		self.iniciar_config_teclado()
		game.onTick(80, "animacion-pacman", { pacmanFrames.avanzar() })
		registry.put("jugador", self)
	}

	// crean el efecto de que alguien los tira hacia el sentido indicado
	method arriba() {
		self.accelerate(0, fuerza * masa)							
		pacmanFrames.orientacion(arriba)
	}
	method abajo() {
		self.accelerate(0, -fuerza * masa)		
		pacmanFrames.orientacion(abajo)					
	}
	method derecha() {
		self.accelerate(fuerza * masa, 0)		
		pacmanFrames.orientacion(derecha)					
	}
	method izquierda() {
		self.accelerate(-fuerza * masa, 0)
		pacmanFrames.orientacion(izquierda)					
	}

//	override method resolverColisionCon(objeto) {
//		game.say(self, "Choque con "+objeto.toString())
//		//self.morir()
//	}		
//	
	method iniciar_config_teclado() {
		keyboard.w().onPressDo { 
			self.arriba()
		}
		keyboard.a().onPressDo { 
			self.izquierda()
		}
		keyboard.s().onPressDo { 
			self.abajo()
		}
		keyboard.d().onPressDo { 
			self.derecha()
		}
		keyboard.q().onPressDo {
			game.stop()
		}
		keyboard.t().onPressDo {
			console.println(self.toString()+": rapidez = "+self.rapidez())
			self.tp(self.x0(), self.y0())
		}
		keyboard.r().onPressDo { // reiniciar su posicion, con velocidad 0
			self.reiniciar()	
		}
		keyboard.k().onPressDo { // matar al jugador
			self.morir()
		}
		keyboard.x().onPressDo { // deletear al jugador
			self.eliminar() // EXISTE MANERA DE BORRAR EL OBJETO DEL PROGRAMA Y NO SOLO DEL MAPA? 
		}
	}
}


class Fantasma inherits VerletObject {
	
	const jugador // se debe definir al crear una instancia
	
	override method image() = "assets/FANTASMA/rojo_arriba1.png"
//	override method image() = "assets/PACMAN/cerrado.png"
	override method initialize() {
		super()
	}
	
	method applyGravity() {
		self.accelerate(0, -g)
	}
	
	method followPlayer() {
		const jugador_pos = jugador.position()
		const a_x = jugador.acc_x()
		const a_y = jugador.acc_y()
	
		// SOLUCIONAR PROBLEMA DE QUE SE PONEN A ORBITAR AL JUGADOR, NUNCA LO ALCANZA
		
		const jugador_vel = jugador_pos - vector.at(jugador.x(),jugador.y()) 
		const diff = jugador_pos - self.position()
		const hacia = (diff + jugador_vel).versor()
		
		self.accelerate(hacia.x(), hacia.y())
	}
	
	override method update() {
//		self.applyGravity()
//		self.followPlayer() 
		super()
	}
	
	override method resolverColisionCon(objeto, vectorCorreccion) {
		super(objeto, vectorCorreccion)
		self.morir()
	}	
}
