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
	var property position = new Vector(x=0, y=0)
	var image = "assets/null.png"
	
//	method initialize() {
//		
//	}
	
	method image() = image
	method image(_image_path) {
		image = _image_path
	}
	
}

//class StaticObject inherits GameObject { // cualquier obstáculo (con el que el jugador se puede chocar) estático
//	// agregar tema de colisiones 
//}

class DynamicObject inherits GameObject {
	method initialize() {
		updater.add(self) // se agrega por su cuenta al updater al crearse una instancia de la clase
	}
	method update()
}


class PhysicsObject inherits DynamicObject {
	var property velocity = new Vector(x=10, y=0)
	var property acceleration = new Vector(x=0, y=0)
	
	const masa = 1
	const coef_friccion = 0.05
	
	override method update() {
		position += velocity
		velocity += acceleration
		velocity -= velocity * coef_friccion // aplicamos friccion

	}
}


//class Pared inherits StaticObject {
//	override method image = "assets/pacman.png" // cambiar imagen por la de una pared
//}

 
class Pacman inherits PhysicsObject {
	const magnitud_fuerza = 15
	
	const spriteHeight = 96			 	// tamaño en pixeles de la imagen utilizada
	const spriteWidth = 96				// se puede observar la dimensión de la imágen en el .png	
	
	override method image() = "assets/pacman.png" 
	
	// crean el efecto de que alguien los tira hacia ese sentido indicado
	method arriba() {
		velocity.y(velocity.y() + magnitud_fuerza * masa)								// aplicar fuerza vertical hacia arriba
	}
	method abajo() {
		//velocity += versor_i * magnitud_fuerza * masa	// con esta, RIP PERFORMANCE 
		velocity.y(velocity.y() - magnitud_fuerza * masa)								// aplicar fuerza vertical hacia abajo
	}
	method derecha() {
		velocity.x(velocity.x() + magnitud_fuerza * masa)								// aplicar fuerza horizontal hacia derecha
	}
	method izquierda() {
		velocity.x(velocity.x() - magnitud_fuerza * masa)								// aplicar fuerza horizontal hacia izquierda
	}
}


// deberiamos detectar la colision con el jugador, 
// pero no entre las distintas instancias de los fantasmas
class Fantasma inherits PhysicsObject {	
	const spriteHeight = 96 			 	// tamaño en pixeles de la imagen utilizada
	const spriteWidth = 96 					// se puede observar la dimensión de la imágen en el .png
	override method image() = "assets/pacman.png" 
	
	override method update() {
		// acá iría la IA de los fantasmas
	}
}


// guardo esto aca

object pacman {
	const property position = new Vector(x=0,y=0) // crear un method position 
	
	// usamos variable propias para x e y,
	// es más rápido que con vectores (ya lo probé, rip performance), ¿¿¿¿con otros tipos de pares ordenados funcionará????
	var x = position.x()
	var y = position.y()
	var property vel_x = 10 				// le damos velocidad-x inicial
	var property vel_y = 0
	const magnitud_fuerza = 15
	// suponemos que su masa es igual a 1.
	
	
	const spriteHeight = 96			 	// tamaño en pixeles de la imagen utilizada
	const spriteWidth = 96				// se puede observar la dimensión de la imágen en el .png
	method image() = "assets/pacman.png" 	// TODO: existe función para obtener las dimensioens de la imagen utilizada ??
	
	
	// crean el efecto de que alguien los tira hacia ese sentido indicado
	method arriba() {
		//position = position.up(pixeles)
		vel_y += magnitud_fuerza * 1						// aplicar fuerza vertical hacia arriba
	}
	method abajo() {
		//position = position.down(pixeles)
		vel_y -= magnitud_fuerza							// aplicar fuerza vertical hacia abajo
	}
	method derecha() {
		//position = position.right(pixeles)
		vel_x += magnitud_fuerza							// aplicar fuerza horizontal hacia derecha
	}
	method izquierda() {
		//position = position.left(pixeles)
		vel_x -= magnitud_fuerza							// aplicar fuerza horizontal hacia izquierda
	}
	
	// todos los updates deben devolver bloques para poder pasarlos como parametros en el actualizador global
	method update() {
		
		x += vel_x
		y += vel_y
		vel_x -= vel_x * 0.05 // aplicamos friccion en eje x
		vel_y -= vel_y * 0.05 // aplicamos friccion en eje y
		
		
		
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
		
		// aplica los cambios de posición
		position.y(y)
		position.x(x)
		
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


