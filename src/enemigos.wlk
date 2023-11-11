import wollok.game.*
import gameObjects.*
import gameEngine.*
import vectores.*
import proyectiles.*



class Fantasma inherits EntesVivos {
	
	const jugador = gameEngine.jugador() // si no funciona, se debe definir al crear una instancia
	const mirandoHacia = norte.versor()
	var congelado = false
	
	var coolDownDisparos = 3500 // en no se que unidad de tiempo
	
	method nuevoCoolDownDisparos(tiempo) {
		coolDownDisparos = tiempo
		self.reiniciarCoolDownDisparos()
	}
	method dejarDeDisparar() {
		gameEngine.removeTickEvent("disparar"+self.identity())	
	}
	method iniciarDisparos() {
		// le ponemos un identificador unico para que no se confunda con el onTickEvent de los demas fantasmas
		gameEngine.onTick(coolDownDisparos, "disparar"+self.identity(), {self.dispararAlJugador()})
	}
	method reiniciarCoolDownDisparos() {
		self.dejarDeDisparar()
		self.iniciarDisparos()
	}
	
	override method vidaMaxima() = 3
	
	override method image() = "assets/FANTASMA/rojo_arriba1.png"
//	override method image() = "assets/PACMAN/cerrado.png"
	override method initialize() {
		super()
		gameEngine.enemigos().add(self)
		self.iniciarDisparos()
	}
	
	method dispararAlJugador() {
		self.mirarAlJugador() // actualiza "mirandoHacia"
		const aceleracionInstantaneaDisparo = 2
		const vectorDisparo = mirandoHacia * aceleracionInstantaneaDisparo 
		
//		const vel_x = x - old_x 
//		const vel_y = y - old_y 
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
	
	method applyMovement() {
		var randomX = (-1..1).anyOne()
	  	var randomY = (-1..1).anyOne()
	  	self.accelerate(randomX, randomY)
	}
	
	override method update(dt) {
//		self.applyGravity()
		self.applyMovement()
		self.applyCirclePathConstraint(registry.get("centro"), 75)
		if (not congelado) {
			self.updatePosition(dt)
		}
		 
	}
	
	override method eliminar() {
		gameEngine.enemigos().remove(self) // lo sacamos primero así deja de detectar sus colisiones
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
