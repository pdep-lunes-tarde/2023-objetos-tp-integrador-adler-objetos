import wollok.game.*
import gameObjects.*
import global.*
import proyectiles.*


class Pacman inherits VerletObject {
	const property fuerza = 5
	const property radio = self.width()/2
	
	override method image() = pacmanFrames.actual()
	
	override method initialize() {
		super()
		game.onTick(80, "animacion-pacman", { pacmanFrames.avanzar() })
		registry.put("jugador", self)
	}

	// crean el efecto de que alguien los tira hacia el sentido indicado
	method arriba() {
		self.accelerate(0, fuerza * masa)							
		pacmanFrames.orientacion(arriba)
	}
	method abajo() {
		self.accelerate(0, -fuerza * masa)		
		pacmanFrames.orientacion(abajo)					
	}
	method derecha() {
		self.accelerate(fuerza * masa, 0)		
		pacmanFrames.orientacion(derecha)					
	}
	method izquierda() {
		self.accelerate(-fuerza * masa, 0)
		pacmanFrames.orientacion(izquierda)					
	}
	method disparar() {
		
	}

//	override method resolverColisionCon(objeto) {
//		game.say(self, "Choque con "+objeto.toString())
//		//self.morir()
//	}		

}










//orientaciones
object derecha {
	override method toString() = "der"
}
object izquierda {
	override method toString() = "izq"
}
object arriba {
	override method toString() = "arriba"
}
object abajo {
	override method toString() = "abajo"
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
	var property orientacion = derecha
	
	var i = 0
	
	method actual() {
		const estadoActual = secuenciaEstados.get(i)
		return "assets/PACMAN/"+estadoActual+"-"+orientacion+".png"
	}
	method avanzar() {
		i++
		if (i==4) {i=0}
	}
	method orientacion(_orientacion) {
		orientacion = _orientacion
	}
}