import wollok.game.*
import gameObjects.*
import global.*
import vectores.*

class Fantasma inherits VerletObject {
	
	const jugador = registry.get("jugador") // si no funciona, se debe definir al crear una instancia
	
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
	
	override method morir() {
		super()
		self.eliminar()
	}
	
	override method resolverColisionCon(objeto) {
		console.println("Colision con "+objeto)
		self.morir()
	}	
}
