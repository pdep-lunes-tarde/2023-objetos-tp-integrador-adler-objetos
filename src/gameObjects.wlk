import wollok.game.*

import gameEngine.*
import vectores.*
import colisiones.*
import ui.*
import mapa.*

// deberia abstraer cosas de GameObject con Visual
// valores iniciales (por si queremos definirlos al momento de crear una instancia de la clase)
// x0, y0, doCollision 
class GameObject {
	const property x0 = registry.get("centro").x() - self.width()/2
	const property y0 = registry.get("centro").y() - self.height()/2
	var property x = x0 	// posicion actual (para hacer cálculos)
	var property y = y0
	
	var property hitbox = null // se genera durante el initialize()

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
		self.mostrar()				
		gameEngine.objetos().add(self)
		hitbox = new Hitbox(objetoAsociado=self)
	}
	
	method mostrar() {
		gameEngine.addVisual(self) 	
	}
	method ocultar() {
		gameEngine.removeVisual(self)
	}
	
	method eliminar() {
		gameEngine.objetos().remove(self)						// los sacamos de la lista global
		self.ocultar()											// dejamos de mostrarlo en el juego
	}
	
	method resolverColisionCon(objeto, vectorCorreccion) {
		game.say(self, "Choque con "+objeto)
//		const vel_x = x - old_x 
//		const vel_y = y - old_y
		x += vectorCorreccion.x()
		y += vectorCorreccion.y()	
//		old_x = x + vel_x	
//		old_y = y + vel_y		
	}
	method resolverColisionCon(objeto) {
		console.println(self.toString()+": Colision con "+objeto)
	}
}


class UpdatableObject inherits GameObject {
	override method initialize() {
		super()
		updater.add(self) 	// se agrega al updater al crearse una instancia de la clase
	}
	override method eliminar() {
		updater.remove(self)									// dejamos de actualizarlo
		super()
	}
	method update(dt) 
}

// valor inicial: x0, y0
class Sangre inherits GameObject {
	override method image() = "assets/PACMAN/sangre3.png" 
	
	override method initialize() {
		super()
		gameEngine.schedule(3000, {self.eliminar()}) 	// se elimina dsp de un rato
	}
}

// se deben dar valores a vel_x0, vel_y0.
class VerletObject inherits UpdatableObject {	
	/* Basado en: https://www.youtube.com/watch?v=lS_qeBy3aQI 
	 * 			  https://www.youtube.com/watch?v=-GWTDhOQU6M 
	 * */  

	const vel_x0 = 0
	const vel_y0 = 0
	 
	var property old_x = x0 - vel_x0 		// posicion anterior
	var property old_y = y0 - vel_y0

	var property acc_x = 0 	 				// aceleración
	var property acc_y = 0
	
	const hayFriccion = true
	
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
	
	method updatePosition(dt) {
		// el valor corresponde al numero de ticks definido en el game.onTick()
		// si los ticks del updater son mayores al valor del dt, entocnes se va a ver en cámara lenta
		
		// calculamos la velocidad con las posiciones actual y anterior
		const vel_x = x - old_x  
		const vel_y = y - old_y
		
		// guardamos las posiciones actuales 
		old_x = x
		old_y = y
			
		// calculamos la nueva posicion con Integración de Verlet (agregue 0.9 para simular friccion)
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
	
	method applyGravity() {
		self.accelerate(0,-g)
	}
	
	method applyCircleConstraint(coord_centro, radio) { // restriccion circular invisible
		const radioDelCirculo = mapa.radioDelCirculo()
		const ejeDeChoque = coord_centro - (vector.at(x, y) + vector.at(radioDelCirculo,radioDelCirculo))
		const dist = ejeDeChoque.magnitud()
		
//		const coef_perdida_energia = 0.05
		
		if (dist > radio) {  // si se sale del circulo, entonces...
			const diff = dist - radio
			const moverHacia = ejeDeChoque.versor() * diff
		
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
	
	method applyCirclePathConstraint(coord_centro, radio) {
		const radioDelCirculo = mapa.radioDelCirculo()
		const ejeDeChoque = coord_centro - (vector.at(x, y) + vector.at(radioDelCirculo,radioDelCirculo))
		const dist = ejeDeChoque.magnitud()
		
		if (dist != radio) {  // si se sale de la linea del perimetro del circulo...
			const diff = dist - radio
			const moverHacia = ejeDeChoque.versor() * diff	
			x += moverHacia.x()
			y += moverHacia.y()
		}
	}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
	
	override method update(dt) {
//		self.applyGravity()
//		self.applyWallConstraint()
		self.updatePosition(dt)
	}
}

class ObjetoConVida inherits VerletObject {
	var property vida = self.vidaMaxima()
	method vidaMaxima()
	
	override method initialize() {
		super()
		hitbox.inscribirEnCirculo(4.5)
	}
	
	method morir() {
		console.println("Rip, "+self+" :(")
		self.eliminar()
	}
	method restarVida(_vida) {
		vida = (vida - _vida).max(0)
		const s = new Sangre(x0=x, y0=y)
		if (vida <= 0) {
			self.morir()
		}
	}
}




