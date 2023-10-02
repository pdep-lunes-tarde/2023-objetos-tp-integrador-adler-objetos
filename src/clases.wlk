import wollok.game.*
import global.updater
import vectores.*

class GameObject {
	var property position
	
	method image()	// peude ser un objeto invisible del juego
}

class DynamicObject inherits GameObject {
	method update()
	updater.add(self) // se 
}

class PhysicsObject inherits DynamicObject {
	var property posicion = new Vector(x=position.x(), y=position.y()) // usamos variable propias para x e y para poder hacer otros calculos
	var property velocidad = new Vector(x=10, y=0)
	var property aceleracion = new Vector(x=0, y=0)
	
	const masa = 1
	const magnitud_fuerza = 15
	var coef_friccion = 0.05
	
	override method update() {
		posicion += velocidad
		velocidad += aceleracion
		velocidad -= velocidad * coef_friccion // aplicamos friccion
		
		position = game.at(x,y)
	}
	
}

class StaticObject inherits GameObject { // cualquier obstáculo (con el que el jugador se puede chocar) estático
	// agregar tema de colisiones 
}

class Pared inherits StaticObject {
	override method image() = "assets/pacman.png" // cambiar imagen por la de una pared
}

