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
	method height() = 60/registry.get("casillas_pixeles")			 	// tamaño en pixeles de la imagen utilizada divido por el tamaño de pixel de una casilla
	method width() = 60/registry.get("casillas_pixeles")				// se puede observar la dimensión de la imágen en el .png
	method image() = "assets/null.png"
	
	override method initialize() {
		super() 
		game.addVisual(self)
		(new FrameDeColision(objetoAsociado=self)).agregarPerimetro(
			new Rectangulo(altura=self.height(), ancho=self.width()), 
			vector.at(0,0)
		)
	}
	
}

class UpdatableObject inherits GameObject {
	override method initialize() {
		super()
		updater.add(self) // se agrega al updater al crearse una instancia de la clase
	}
	method update() 
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


class VerletObject {
	
	const frameDeColision = new List() // lista de puntos de colision
	
	/* Basado en: https://www.youtube.com/watch?v=lS_qeBy3aQI
	 * 			  https://www.youtube.com/watch?v=-GWTDhOQU6M 
	 * */  
	// valores iniciales (por si queremos definirlos al momento de crear una instancia de VerletObject)
	const x0 = game.center().x() 
	const y0 = game.center().y() 
//	const vel_x0 = 0
//	const vel_y0 = 0
	
	var property pos_x = x0 					// posicion actual (para hacer cálculos)
	var property pos_y = x0
	var property position = new Vector(x=x0, y=y0) // posicion actual (para wollok) 
	var pos_old_x = x0 //- vel_x0 	// posicion anterior
	var pos_old_y = x0 //- vel_y0
	var property acc_x = 0 	 				// aceleración
	var property acc_y = 0
	
	const g = 0.981 * registry.get("coef")
	
	override method initialize() {
		updater.add(self)
		game.addVisual(self)
	}
	method height() = 45/registry.get("casillas_pixeles")	
	method width() = 45/registry.get("casillas_pixeles")	
	method image() = "assets/null.png"
	
	method controlColisiones() {
		// vemos si en el camino entre pos_old y pos hay algun obstaculo 
		 
	}
	
	method updatePosition(dt) {
		// el valor corresponde al numero de ticks definido en el game.onTick()
		// si los ticks del updater son mayores al valor del dt, entocnes se va a ver en cámara lenta
		
		// calculamos la velocidad con las posiciones actual y anterior
		const vel_x = pos_x - pos_old_x  
		const vel_y = pos_y - pos_old_y
		
		// guardamos las posiciones actuales 
		pos_old_x = pos_x
		pos_old_y = pos_y
			
		// calculamos la nueva posicion con Integración de Verlet (agregue 0.95 para simular friccion)
		pos_x += vel_x * 0.95 + acc_x *dt*dt 
		pos_y += vel_y * 0.95 + acc_y *dt*dt
		
		self.controlColisiones() // antes de aplicar cambios, verificamos si pos_x y pos_y chocan algo
		
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
	
	method applyConstraint() {
		const pos = new Vector(x=30, y=16)
		const radius = 5
		const to_obj = vector.at(pos_x,pos_y) - pos
		const dist = to_obj.magnitud()
		if (dist > radius - 3) {
			const n = to_obj / dist
			const v = (pos + n * (radius - 3))
			pos_x = v.x()
			pos_y = v.y()
		}
	}
	
	method applyWallConstraint(dt) {
		const piso = 0
		const techo = registry.get("window_height") - self.height() // hay q tener en cuenta el tamaño del sprite,
		const derecha = registry.get("window_width") - self.width() // ya que el pivot está en la esquina abajo-izquierda del sprite.
		const izquierda = 0
		
		const vel_x = (pos_x - pos_old_x)/dt  
		const vel_y = (pos_y - pos_old_y)/dt
		
		if (pos_y < piso) {	 								// cuando encuentra el piso
			pos_y = piso
			pos_old_y = pos_y + vel_y 						
		}
		if (pos_x < izquierda) { 
			pos_x = izquierda
			pos_old_x = pos_x + vel_x
		}
		if (pos_y > techo) { 								// cuando encuentra el techo
			pos_y = techo
			pos_old_y = pos_y + vel_y
		}									
		if (pos_x > derecha) {					
			pos_x = derecha
			pos_old_x = pos_x + vel_x
		}
		
	}

	method update(dt) {
		self.applyWallConstraint(dt)
		//self.applyConstraint()
		self.updatePosition(dt) 
	}
	
	
	method colisionConObstaculo(obstaculo) {
		const eje_colision = self.position() - self.position() // solo nos importa el ángulo de este vector, para conocer la direccion del rebote
		
		
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
		
		const jugador_vel = jugador_pos - vector.at(jugador.pos_x(),jugador.pos_y()) 
		const diff = jugador_pos - self.position()
		var hacia = diff + jugador_vel
		hacia = hacia / hacia.magnitud()
		
		
		const c = registry.get("coef")
		self.accelerate(hacia.x()*c, hacia.y()*c)
	}
	override method update(dt) {
		//self.applyGravity()
		self.followPlayer() 
		super(dt) 
	}
	
	
	// resuelve la colision entre fantasma y jugador
	method colisionConJugador() {
		
	}
	
	
}

const jugador = new Pacman()
class Pacman inherits VerletObject {
	const property  fuerza = 3 * registry.get("coef")
	
	var orientacion = "der"
	var animacionEstado = "cerrado"
	var aux = "cerrado"+"-"+orientacion
	
	const masa = 1
	
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


