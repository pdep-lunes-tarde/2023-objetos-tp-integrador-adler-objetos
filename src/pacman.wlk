import wollok.game.*
import gameObjects.*
import global.*
import proyectiles.*
import vectores.*


class Pacman inherits EntesVivos {
	const property fuerza = 5
	const property radio = self.width()/2
	var property orientacion = derecha 
	
	override method image() = pacmanFrames.actual(self)
	
	override method initialize() {
		super()
		game.onTick(80, "animacion-pacman", { pacmanFrames.avanzar() })
		registry.put("jugador", self)
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
		const proyectil = new ProyectilJugador(x0=x,y0=y, 
			vel_x0=vel_x, 
			vel_y0=vel_y
		)
		const sentidoDelDisparo = self.orientacion().versor()
		const aceleracionInstantaneaDisparo = 10
		const vectorDisparo = sentidoDelDisparo * aceleracionInstantaneaDisparo 
		proyectil.accelerate(vectorDisparo)
	}

//	override method resolverColisionCon(objeto) {
//		game.say(self, "Choque con "+objeto.toString())
//		//self.morir()
//	}		

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