import wollok.game.*
import gameObjects.*
import gameEngine.*
import proyectiles.*
import vectores.*

class Pacman inherits EntesVivos {
	const property fuerza = 2
	const property radio = self.width()/2
	var property orientacion = derecha 
	
	var property tipoProyectilActivo = piedra
	
	method activarTipoProyectil(_tipo) {
		tipoProyectilActivo = _tipo
	} 
	override method vidaMaxima() = 3
	
	override method image() = pacmanFrames.actual(self)
	
	override method initialize() {
		super()
		gameEngine.onTick(80, "animacion-pacman", { pacmanFrames.avanzar() })
		gameObjects.jugador(self)
	}
	
	method orientacion(_orientacion) {
		orientacion = _orientacion
	}
	method arriba() {
		self.accelerate(0, fuerza)							
		self.orientacion(arriba)
	}
	method abajo() {
		self.accelerate(0, -fuerza)		
		self.orientacion(abajo)					
	}
	method derecha() {
		self.accelerate(fuerza, 0)		
		self.orientacion(derecha)					
	}
	method izquierda() {
		self.accelerate(-fuerza, 0) 
		self.orientacion(izquierda)					
	}
	method disparar() {
		const vel_x = x - old_x
		const vel_y = y - old_y // la velocidad relativa del proyectil se debe sumar a la del jugador para obtener su velocidad absoluta.
		const proyectil = new ProyectilJugador(
			tipo = self.tipoProyectilActivo(),
			hayFriccion=false, 
			x0=x, y0=y, 
			vel_x0=0, 
			vel_y0=0
		)
		const sentidoDelDisparo = self.orientacion().versor()
		const aceleracionInstantaneaDisparo = 6
		const vectorDisparo = sentidoDelDisparo * aceleracionInstantaneaDisparo 
		proyectil.accelerate(vectorDisparo)
	}
	
	method activarHiperactividad() {
		console.println("za warudo")
	}
	
	override method update(dt) {
		self.applyCircleConstraint(registry.get("centro"), 60)
		super(dt)
	}

}





//orientaciones
object derecha {
	override method toString() = "der"
	method versor() = este.versor() 
}
object izquierda {
	override method toString() = "izq"
	method versor() = oeste.versor()
}
object arriba {
	override method toString() = "arriba"
	method versor() = norte.versor()
}
object abajo {
	override method toString() = "abajo"
	method versor() = sur.versor()
}
//estados
object cerrado {
	override method toString() = "cerrado"
}
object medio {
	override method toString() = "medio"
}
object abierto {
	override method toString() = "abierto"
	
}
object pacmanFrames {
	const secuenciaEstados = [cerrado, medio, abierto, medio]
	
	var i = 0 // lleva la cuenta del estado actual
	method actual(jugador) {
		const estadoActual = secuenciaEstados.get(i)
		return "assets/PACMAN/"+estadoActual+"-"+jugador.orientacion()+".png"
	}
	method avanzar() {
		i++
		if (i==4) {i=0}
	}
}