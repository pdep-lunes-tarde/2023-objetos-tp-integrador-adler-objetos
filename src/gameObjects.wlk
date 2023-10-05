import wollok.game.*
import global.*
import vectores.*
import global.*



class GameObject {
	// usamos variable propias x e y,
	// hace los cálculos muchisimo más rápido que los Vectores (ya lo probé, rip performance), ¿¿¿¿con otros tipos de pares ordenados funcionará????
	var property x = 0
	var property y = 0
	// "position" es lo que le importa a wollok game,
	// por ende usamos "position" nomás para efectuar el cambio de posición. Utilizamos un vector mutable que entiende mensajes "x()" e "y()".
	const property position = new Vector(x=x, y=y) // wollok game debe poder leer la posicion, por ende es property
	var image = "assets/null.png"
	
	method image() = image
	method image(_image_path) {
		image = _image_path
	}
	
	override method initialize() {
		super()
		
	}
	
}

class DynamicObject inherits GameObject {
	override method initialize() {
		super()
		updater.add(self) // se agrega al updater al crearse una instancia de la clase
	}
	method update() 
}


class PhysicsObject inherits DynamicObject {
	var vel_x = 10 // magnitud en pixeles por milisegundo
	var vel_y = 10
	var acel_x = 0 // pixeles por milisegundo al cuadrado 
	var acel_y = 0
	
	const masa = 1
	const coef_friccion = 0.05
	
	override method initialize() {
		super()	
		vel_x = 10	
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
		position.at(x, y)
	}
	
	method control() // método abstracto
}

class Pacman inherits PhysicsObject {
	const magnitud_fuerza = 20
	
	const spriteHeight = 96			 	// tamaño en pixeles de la imagen utilizada
	const spriteWidth = 96				// se puede observar la dimensión de la imágen en el .png
	override method image() = "assets/pacman.png" 	
	
	// crean el efecto de que alguien los tira hacia el sentido indicado
	method arriba() {
		vel_y += magnitud_fuerza * masa							// aplicar fuerza vertical hacia arriba
	}
	method abajo() {
		vel_y -= magnitud_fuerza * masa							// aplicar fuerza vertical hacia abajo
	}
	method derecha() {
		vel_x += magnitud_fuerza * masa							// aplicar fuerza horizontal hacia derecha
	}
	method izquierda() {
		vel_x -= magnitud_fuerza * masa							// aplicar fuerza horizontal hacia izquierda
	}
	
	override method control() {
		// para que no se salga de la ventana
		const piso = 0
		const techo = registry.get("window_height") - spriteHeight // hay q tener en cuenta el tamaño del sprite,
		const derecha = registry.get("window_width") - spriteWidth // ya que el pivot está en la esquina abajo-izquierda del sprite.
		const izquierda = 0
		
		if (y < piso) {	 								// cuando encuentra el piso
			y = piso
			vel_y = (-vel_y * 0.6)						// hacemos que rebote con una leve perdida de energia 	
		}
		if (x < izquierda) { 
			x = izquierda
			vel_x = (-vel_x * 0.6)
		}
		if (y > techo) { 								// cuando encuentra el techo
			y = techo
			vel_y = (-vel_y * 0.6)   		
		}									
		if (x > derecha) {					
			x = derecha
			vel_x = (-vel_x * 0.6)
		} 
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


