import wollok.game.*
import gameObjects.*
import global.*
import vectores.*
import proyectiles.*

class Fantasma inherits EntesVivos {
	
	const jugador = gameObjects.jugador() // si no funciona, se debe definir al crear una instancia
	const mirandoHacia = norte.versor()
	
	override method image() = "assets/FANTASMA/rojo_arriba1.png"
//	override method image() = "assets/PACMAN/cerrado.png"
	override method initialize() {
		super()
		gameObjects.enemigos().add(self)
		game.onTick(1000, "dispararAlPacman", { self.dispararAlJugador() })
	}
	
	method dispararAlJugador() {
		const vel_x = x - old_x 
		const vel_y = y - old_y 
		self.mirarAlJugador() // actualiza "mirandoHacia"
		const aceleracionInstantaneaDisparo = 5
		const vectorDisparo = mirandoHacia * aceleracionInstantaneaDisparo 
		
		const proyectil = new ProyectilEnemigo(
			hayFriccion=false,
			x0=x, y0=y,
			vel_x0=0, 
			vel_y0=0
		)		
		proyectil.accelerate(vectorDisparo)
	}
	
	method mirarAlJugador() {
		const jugador_pos = jugador.position()
		const pos = self.position()
		
		const jugador_pos_x = jugador_pos.x()
		const jugador_pos_y = jugador_pos.y()
		const pos_x = pos.x()
		const pox_y = pos.y()
		
//		const desplazamiento = jugador_pos - pos
		const desplazamiento_x = jugador_pos_x - pos_x
		const desplazamiento_y = jugador_pos_y - pox_y
		
//		const hacia = desplazamiento.versor()
		const desplazamiento_magnitud = (desplazamiento_x**2+desplazamiento_y**2).squareRoot() 
		const hacia_x = desplazamiento_x / desplazamiento_magnitud
		const hacia_y = desplazamiento_y / desplazamiento_magnitud
		
		// mejor rendimiento modificar un vector ya existente que crear uno nuevo cada vez que se llama la funcion
		mirandoHacia.xy(hacia_x, hacia_y) // actualizamos la mirada del fantasma 
	}
	
	override method update() {
//		self.applyGravity()
		self.applyCirclePathConstraint(registry.get("centro"), 75)
		self.updatePosition(1) 
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
