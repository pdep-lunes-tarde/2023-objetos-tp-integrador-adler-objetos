import wollok.game.*

import global.*
import vectores.*
import colisiones.*



class GameObject {
	// usamos variable propias x e y,
	// hace los cálculos muchisimo más rápido que los Vectores (ya lo probé, rip performance), ¿¿¿¿con otros tipos de pares ordenados funcionará????
	var property x = 0
	var property y = 0
	// "position" es lo que le importa a wollok game,
	// por ende usamos "position" nomás para efectuar el cambio de posición. Utilizamos un vector mutable que entiende mensajes "x()" e "y()".
	const property position = vector.at(x,y) // wollok game debe poder leer la posicion, por ende es property
	
	var property frameDeColision = null // definirlo con (new FrameDeColision())
	
	method asignarFrame(_frameDeColision) {
		frameDeColision = _frameDeColision
	}
	method spriteHeight() = 50/registry.get("casillas_pixeles")			 	// tamaño en pixeles de la imagen utilizada divido por el tamaño de pixel de una casilla
	method spriteWidth() = 50/registry.get("casillas_pixeles")				// se puede observar la dimensión de la imágen en el .png
	method image() = "assets/null.png"
	
	override method initialize() {
		super() 
		game.addVisual(self)
//		(new FrameDeColision(objetoAsociado=self)).agregarPerimetro(
//			new Rectangulo(altura=self.spriteHeight(), ancho=self.spriteWidth()), 
//			vector.at(0,0)
//		)
	}
	
}

class UpdatableObject inherits GameObject {
	override method initialize() {
		super()
		updater.add(self) // se agrega al updater al crearse una instancia de la clase
	}
	method update() 
}


class ObjetosQueSaltan inherits VerletObject {
	override method image() = "assets/FANTASMA/rojo_arriba1.png"
	override method initialize() {
		super()
		game.onTick(1, "saltar", {
			if (pos_y <= 0) {
				self.accelerate(0, 2)
				self.accelerate((-1).randomUpTo(1), 0)
			}
		})
	}
}

class VerletObject {
	/* Basado en: https://www.youtube.com/watch?v=lS_qeBy3aQI 
	 * */
	// valores iniciales (por si queremos definirlos al momento de crear una instancia de VerletObject)
	const x0 = 0  
	const y0 = 0 
//	const vel_x0 = 0
//	const vel_y0 = 0
	
	var pos_x = x0 					// posicion actual (para hacer cálculos)
	var pos_y = x0
	var property position = new Vector(x=x0, y=y0) // posicion actual (para wollok) 
	var pos_old_x = x0 //- vel_x0 	// posicion anterior
	var pos_old_y = x0 //- vel_y0
	var acc_x = 0 	 				// aceleración
	var acc_y = 0
	
	override method initialize() {
		updater.add(self)
		game.addVisual(self)
	}
	method spriteHeight() = 50/registry.get("casillas_pixeles")	
	method spriteWidth() = 50/registry.get("casillas_pixeles")	
	method image() = "assets/null.png"
	
	method updatePosition() {
		// el valor corresponde al numero de ticks definido en el game.onTick()
		const dt = 1 // si incremento los ticks del updater, pero no del dt, entocnes se va a ver en cámara lenta
		
		// calculamos la velocidad con las posiciones actual y anterior
		const vel_x = pos_x - pos_old_x
		const vel_y = pos_y - pos_old_y
		
		// guardamos las posiciones actuales 
		pos_old_x = pos_x
		pos_old_y = pos_y
				
		// actualizamos la posicion 
		pos_x += vel_x + acc_x *dt*dt 
		pos_y += vel_y + acc_y *dt*dt
		
		// reiniciamos el valor de la aceleracion
		acc_x = 0
		acc_y = 0 
		
		// aplicamos cambios en wollok game
		position.xy(pos_x, pos_y)
	}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
	
	method accelerate(_acc_x, _acc_y) {
		acc_x += _acc_x
		acc_y += _acc_y
	}
	
	method applyGravity() {
		self.accelerate(0, -0.1)
	}
	
	method applyConstraint() {
		const pos = new Vector(x=100, y=100)
		const radius = 50
		const to_obj = position - pos
		const dist = to_obj.magnitud()
		if (dist > radius - 20) {
			const n = to_obj / dist
			position.xy(pos + n * (radius - 20))
		}
	}
	
	method applyWallConstraint() {
		const piso = 0
		const techo = registry.get("window_height") - self.spriteHeight() // hay q tener en cuenta el tamaño del sprite,
		const derecha = registry.get("window_width") - self.spriteWidth() // ya que el pivot está en la esquina abajo-izquierda del sprite.
		const izquierda = 0
		
		if (pos_y < piso) {	 								// cuando encuentra el piso
			pos_y = piso
			pos_old_y = piso
		}
		if (pos_x < izquierda) { 
			pos_x = izquierda
			pos_old_x = izquierda
		}
		if (pos_y > techo) { 								// cuando encuentra el techo
			pos_y = techo
			pos_old_y = techo
		}									
		if (pos_x > derecha) {					
			pos_x = derecha
			pos_old_x = derecha
		}
		
	}
	
	method update() {
		self.applyGravity()
		self.applyWallConstraint()
		//self.applyConstraint()
		self.updatePosition() 
	}
}

class PhysicsObject inherits UpdatableObject {
	var property vel_x = 0 // magnitud en pixeles por milisegundo
	var property vel_y = 0
	var property acel_x = 0 // pixeles por milisegundo al cuadrado 
	var property acel_y = 0
	
	const masa = 1
	const coef_friccion = 0.05
	
	override method initialize() {
		super()	
		vel_x = 20	
		vel_y = 10
	}
	
	override method update() {
		// actualizamos las cantidades fisicas
		x += vel_x
		y += vel_y
		vel_x += acel_x
		vel_y += acel_y
		vel_x -= vel_x * coef_friccion // si usamos Masa, entonces debemos cambiar esta implementacion.
		vel_y -= vel_y * coef_friccion
		
		// controlamos los valores antes de efectuar los cambios 
		self.control() 
		
		// efectuamos los cambios
		position.xy(x, y)
	}
	
	method control() {
		self.controlColisiones()
	}
	
	method controlColisiones() {
 		frameDeColision.perimetro().forEach { ptoColision =>
			ptoColision.pivote_x(x)
			ptoColision.pivote_y(y)
		}
 	}
}

class Pacman inherits PhysicsObject {
	const property magnitud_fuerza = 5 / registry.get("casillas_pixeles")
	
	var orientacion = "der"
	var animacionEstado = "abierto"
	var aux = "abierto"+"-"+orientacion
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
		
//		game.whenCollideDo(self, {x => 
//			frameDeColision.forEach { ptoColision => 
//				if (not (x === ptoColision)) {
//					game.say(self, "Choque a " + x.identity())
//				} 
//			}	
//		})
		
		
		game.onTick(100, "animacion-pacman", { 
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
			}
		)
	}
	 
	
	// crean el efecto de que alguien los tira hacia el sentido indicado
	method arriba() {
		vel_y += magnitud_fuerza * masa							
		orientacion = "arriba"
	}
	method abajo() {
		vel_y -= magnitud_fuerza * masa	
		orientacion = "abajo"						
	}
	method derecha() {
		vel_x += magnitud_fuerza * masa	
		orientacion = "der"						
	}
	method izquierda() {
		vel_x -= magnitud_fuerza * masa
		orientacion = "izq"							
	}
	
	
	override method control() {
		// para que no se salga de la ventana
		const piso = 0
		const techo = registry.get("window_height") - self.spriteHeight() // hay q tener en cuenta el tamaño del sprite,
		const derecha = registry.get("window_width") - self.spriteWidth() // ya que el pivot está en la esquina abajo-izquierda del sprite.
		const izquierda = 0
		
		const porcentaje_rebote = 0.3
		
		if (y < piso) {	 								// cuando encuentra el piso
			y = piso
			vel_y = (-vel_y * porcentaje_rebote)						// hacemos que rebote con una leve perdida de energia 	
		}
		if (x < izquierda) { 
			x = izquierda
			vel_x = (-vel_x * porcentaje_rebote)
		}
		if (y > techo) { 								// cuando encuentra el techo
			y = techo
			vel_y = (-vel_y * porcentaje_rebote)   		
		}									
		if (x > derecha) {					
			x = derecha
			vel_x = (-vel_x * porcentaje_rebote)
		}
		
		
		
//		super()
	}
	
	
}




//// deberiamos detectar la colision con el jugador, 
//// pero no entre las distintas instancias de los fantasmas
//class Fantasma {
//	var property position = game.at(0,0) // inicia los fantasmas en el (0,0)
//	
//	// unidad: pixel
//	var x = position.x() 					// usamos variable propias para x e y para poder hacer otros calculos
//	var y = position.y()
//	
//	const spriteHeight = 96 			 	// tamaño en pixeles de la imagen utilizada
//	const spriteWidth = 96 					// se puede observar la dimensión de la imágen en el .png
//	method image() = "assets/pacman.png" 
//	
//	method update() {
//		// acá iría la IA de los fantasmas
//	}
//}


