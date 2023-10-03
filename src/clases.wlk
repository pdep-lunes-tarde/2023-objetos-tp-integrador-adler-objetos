import wollok.game.*
import global.updater
import vectores.*
import global.*


class collisionObject {
	var property position = new Vector(x=0, y=0)
	
}

class perimetroDeColision {
	const perimeter = new List() // lista que contiene
	
}

class GameObject {
	// usamos variable propias para x e y,
	// hace los cálculos más rápido que los Vectores (ya lo probé, rip performance), ¿¿¿¿con otros tipos de pares ordenados funcionará????
	var property x = 0
	var property y = 0
	// vector mutable. "position" es lo que le importa a wollok game,
	// por ende usamos "position" nomás para efectuar el cambio de posición.
	const property position = new Vector(x=x, y=y) // wollok game debe poder leer la posicion, por ende es property
	var image = "assets/null.png"
	
	method image() = image
	method image(_image_path) {
		image = _image_path
	}
}

class DynamicObject inherits GameObject {
	method initialize() {
		updater.add(self) // se agrega por su cuenta al updater al crearse una instancia de la clase
	}
	method update()
}

class PhysicsObject inherits DynamicObject {
	var property vel_x = 10
	var property vel_y = 20
	var property acel_x = 0
	var property acel_y = -0.9
	
	const masa = 1
	const coef_friccion = 0.05
	
	override method update() {
		x += vel_x
		y += vel_y
		vel_x += acel_x
		vel_y += acel_y
		vel_x -= vel_x * coef_friccion // si usamos Masa, entonces debemos cambiar esta implementacion.
		vel_y -= vel_y * coef_friccion
		
		self.control()
		
		// efectuamos los cambios
		position.y(y)
		position.x(x)
	}
	
	method control()
}

object pacman inherits PhysicsObject {
	const magnitud_fuerza = 20
	
	const spriteHeight = 96			 	// tamaño en pixeles de la imagen utilizada
	const spriteWidth = 96				// se puede observar la dimensión de la imágen en el .png
	method image() = "assets/pacman.png" 	
	
	// crean el efecto de que alguien los tira hacia ese sentido indicado
	method arriba() {
		//position = position.up(pixeles)
		vel_y += magnitud_fuerza * masa						// aplicar fuerza vertical hacia arriba
	}
	method abajo() {
		//position = position.down(pixeles)
		vel_y -= magnitud_fuerza * masa							// aplicar fuerza vertical hacia abajo
	}
	method derecha() {
		//position = position.right(pixeles)
		vel_x += magnitud_fuerza * masa							// aplicar fuerza horizontal hacia derecha
	}
	method izquierda() {
		//position = position.left(pixeles)
		vel_x -= magnitud_fuerza * masa							// aplicar fuerza horizontal hacia izquierda
	}
	
	override method control() {
		// para que no se salga de la ventana
		const piso = 0
		const techo = registry.get("window_height") - spriteHeight // hay q tener en cuenta el tamaño del sprite,
		const derecha = registry.get("window_width") - spriteWidth // ya que el pivot está en la esquina abajo-izquierda del sprite.
		const izquierda = 0
		
		if (y < piso) {	 					// cuando encuentra el piso
			y = piso
			//vel_y = -vel_y * 0.6  		// hace que rebote, medio bugatti
		} 
		if (x < izquierda) { 
			x = izquierda
		}
		if (y > techo) { 					// cuando encuentra el techo
			y = techo   		
		}									
		if (x > derecha) {					
			x = derecha    
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


