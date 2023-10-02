import wollok.game.*
import global.updater
import vectores.*

//class GameObject {
//	var property position // esto es lo que le importa a wollok game
//	var property posicion = new Vector(x=0, y=0)
//	self.aplicarPosicion() // aplicamos nuestro var "posicion" en "position" para cambiar posicion efectivamente en wollok game.
//	
//	method aplicarPosicion() {
//		position = game.at(posicion.x(),posicion.y())
//	}
//	
//	method image()	// peude ser un objeto invisible del juego
//}

class StaticObject inherits GameObject { // cualquier obstáculo (con el que el jugador se puede chocar) estático
	// agregar tema de colisiones 
}

class DynamicObject inherits GameObject {
	method update()
	
	updater.add(self) // se agrega solo al updater
}


class PhysicsObject inherits DynamicObject {
	var property position
	var property posicion = new Vector(x=position.x(), y=position.y()) 
	var property velocidad = new Vector(x=10, y=0)
	var property aceleracion = new Vector(x=0, y=0)
	var image = "assets/pacman.png"
	
	const masa = 1
	const magnitud_fuerza = 15
	var coef_friccion = 0.05
	
	method image() = image
	method image(_image_path) {image = _image_path}
	
	override method update() {
		posicion += velocidad
		velocidad += aceleracion
		velocidad -= velocidad * coef_friccion // aplicamos friccion
		
		position = game.at(posicion.x(),posicion.y()) // aplicamos los efectos a la posición
	}
	
}



class Pared inherits StaticObject {
	override method image() = "assets/pacman.png" // cambiar imagen por la de una pared
}

