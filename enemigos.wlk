import wollok.game.*
import gameObjects.*
import gameEngine.*
import vectores.*
import proyectiles.*


class Fantasma inherits ObjetoConVida {
	
	const jugador = gameEngine.jugador() 
	const mirandoHacia = norte.versor()
	var congelado = false
	
	var coolDownDisparos = 3500 
	
	method nuevoCoolDownDisparos(tiempo) {
		coolDownDisparos = tiempo
		self.reiniciarCoolDownDisparos()
	}
	method dejarDeDisparar() {
		gameEngine.removeTickEvent("disparar"+self.identity())	
	}
	method iniciarDisparos() {
		
		gameEngine.onTick(coolDownDisparos, "disparar"+self.identity(), {self.dispararAlJugador()})
	}
	method reiniciarCoolDownDisparos() {
		self.dejarDeDisparar()
		self.iniciarDisparos()
	}
	
	override method vidaMaxima() = 3
	
	override method image() = "assets/FANTASMA/rojo_arriba1.png"

	override method initialize() {
		super()
		gameEngine.enemigos().add(self)
		self.iniciarDisparos()
	}
	
	method dispararAlJugador() {
		self.mirarAlJugador() 
		const aceleracionInstantaneaDisparo = 2
		const vectorDisparo = mirandoHacia * aceleracionInstantaneaDisparo 
		


		const proyectil = new ProyectilEnemigo(
			tipo = fuego,
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
		

		const desplazamiento_x = jugador_pos_x - pos_x
		const desplazamiento_y = jugador_pos_y - pox_y
		

		const desplazamiento_magnitud = (desplazamiento_x**2+desplazamiento_y**2).squareRoot() 
		const hacia_x = desplazamiento_x / desplazamiento_magnitud
		const hacia_y = desplazamiento_y / desplazamiento_magnitud
		
		
		mirandoHacia.xy(hacia_x, hacia_y) 
	}
	
	method applyMovement() {
		const randomX = (-1..1).anyOne()
	  	const randomY = (-1..1).anyOne()
	  	self.accelerate(randomX, randomY)
	}
	
	override method update(dt) {

		self.applyMovement()
		self.applyCirclePathConstraint(registry.get("centro"), 75)
		if (not congelado) {
			self.updatePosition(dt)
		}
		 
	}
	
	override method eliminar() {
		gameEngine.enemigos().remove(self) 
		self.dejarDeDisparar()
		super()
	}
	
	method congelarUnRato() {
		congelado = true 
		gameEngine.schedule(3000, {congelado = false})
	}
	
	override method resolverColisionCon(objeto) {
		console.println("Colision con "+objeto)
	}
	
	override method morir() {
		console.println("Rip, "+self+" :(")
		self.eliminar()
		gameEngine.jugador().sumarPuntos(1000)
	}
}
