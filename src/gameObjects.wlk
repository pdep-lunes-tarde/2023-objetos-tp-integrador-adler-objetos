import wollok.game.*

import global.*
import vectores.*
import colisiones.*



class GameObject {
	// valores iniciales (por si queremos definirlos al momento de crear una instancia de la clase)
	const property x0 = registry.get("centro").x() - self.width()/5
	const property y0 = registry.get("centro").y() - self.height()/5
	const vel_x0 = 0
	const vel_y0 = 0

	// "position" es lo que le importa a wollok game,
	// por ende usamos "position" nomás para efectuar el cambio de posición. 
	// Utilizamos un vector mutable que entiende mensajes "x()" e "y()".
	var property position = new Vector(x=x0, y=y0) 				// posicion actual (para wollok)
	
	const property frameDeColision = new List() 				// lista de puntos de colision. Variable constante, pero lista mutable. 
																//Con poder acceder a esta ya podemos modificarla a gusto.
	
	method height() = 45/registry.get("casillas_pixeles")		// tamaño en pixeles de la imagen utilizada divido por el tamaño de pixel de una casilla
	method width() = 45/registry.get("casillas_pixeles")		// se puede observar la dimensión de la imágen en el .png
	method image() = "assets/null.png"
	
	override method initialize() {
		super() 
		game.addVisual(self) 									// se muestra automáticamente en pantalla al crearse una instancia de la clase
	}

	method eliminar() {
		game.removeVisual(self)
	}
}
class UpdatableObject inherits GameObject {
	override method initialize() {
		super()
		updater.add(self) 	// se agrega al updater al crearse una instancia de la clase
	}
	method update() 
}

// valor inicial: en
class Sangre inherits GameObject {
	override method image() = "assets/PACMAN/sangre3.png"
	
	override method initialize() {
		super()
		game.schedule(3000, {game.removeVisual(self)}) 	// se elimina dsp de un rato
	}
}

class VerletObject inherits UpdatableObject {	
	/* Basado en: https://www.youtube.com/watch?v=lS_qeBy3aQI
	 * 			  https://www.youtube.com/watch?v=-GWTDhOQU6M 
	 * */  
	
	/* usamos variable propias x e y, hace los cálculos muchisimo 
	 * más rápido que los Vectores (ya lo probé, rip performance), 
	 * ¿¿¿¿con otros tipos de pares ordenados funcionará???? 
	 * */
	var property x = x0 					// posicion actual (para hacer cálculos)
	var property y = y0
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
		const s = new Sangre(x0=x, y0=y)
		//self.eliminar()
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
	
	method ColisionConOtroVerletObject() {
		/* https://www.youtube.com/watch?v=eED4bSkYCB8
		 * - Checkear cada par -> HORRIBLE
		 * - Sweep & Prune -> método de los intervalos -> muuuuuuuuuchisimo mejor q el anterior
		 * - Space partitioning -> Uniform grids / K-D Trees /  
		 */
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
			x += vel_x * 0.95 + acc_x *dt*dt 
			y += vel_y * 0.95 + acc_y *dt*dt
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
	
	method applyCircleConstraint(posicion, radio) { // trampa circular invisible
		const circulo_centro = posicion
		const ejeDeChoque = circulo_centro - vector.at(x, y)
		const dist = ejeDeChoque.magnitud()
		
		const coef_perdida_energia = 0.05
		
		if (dist > radio) {  // si se sale del circulo, entonces...
			const diff = dist - radio
			const moverHacia = ejeDeChoque.versor() * diff
		
			if (self.estaEnRapidezLetal(ejeDeChoque)) {
				self.morir()
			}
			/* A GRANDES VELOCIDADES, SE BUGGEA, SOLUCIONES:
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
			//self.applyGravity()
			self.applyWallConstraint()
			self.applyCircleConstraint(registry.get("centro"), 65)
			self.updatePosition(sub_dt) 
		}
	}
	
	method colisionConObstaculo(obstaculo) {
		const eje_colision = obstaculo.position() - self.position()
			
	}
}

class Fantasma inherits VerletObject {
	override method image() = "assets/FANTASMA/rojo_arriba1.png"
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
		self.applyGravity()
		//self.followPlayer() 
		super()
	}
	
	
	// resuelve la colision entre fantasma y jugador
	method colisionConJugador() {
		
	}
	
	
}

const jugador = new Pacman()
class Pacman inherits VerletObject {
	const property fuerza = 20
	
	var orientacion = "der"
	var animacionEstado = "cerrado"
	var aux = "cerrado"+"-"+orientacion
	
	override method image() = "assets/PACMAN/"+aux+".png"
	
	/* PARA LAS COLISIONES. 
	 * DIVIDIR LA PANTALLA EN VARIAS CELDAS, DEBEN SER MAS GRANDES QUE LAS DE WOLLOK
	 * LLEVAR REGISTRO INDIVIDUAL DE LAS CELDAS QUE OCUPA CADA GAMEOBJECT
	 * SI OTRO GAMEOBJECT COMPARTE ALGUNA CELDA SIMULTANEAMENTE CON EL JUGADOR...
	 * ENTONCES, VERIFICAMOS SI EN ESA CELDA SE DA REALMENTE UNA COLISION. 
	 * 
	 * */
	
	override method initialize() {
		super()		
		game.onTick(80, "animacion-pacman", { 
			if(animacionEstado == "abierto") {
				animacionEstado = "medio"
				aux = animacionEstado+"-"+orientacion
			} 
			else if(animacionEstado == "medio") {
				animacionEstado = "cerrado"
				aux = animacionEstado 
			} 
			else {
				animacionEstado = "abierto"
				aux = animacionEstado+"-"+orientacion
			}
		})
	}
	 
	// crean el efecto de que alguien los tira hacia el sentido indicado
	method arriba() {
		self.accelerate(0, fuerza * masa)							
		orientacion = "arriba"
	}
	method abajo() {
		self.accelerate(0, -fuerza * masa)		
		orientacion = "abajo"						
	}
	method derecha() {
		self.accelerate(fuerza * masa, 0)		
		orientacion = "der"						
	}
	method izquierda() {
		self.accelerate(-fuerza * masa, 0)
		orientacion = "izq"							
	}
	
	method colisionConFantasma() {
		
	}
	
}


