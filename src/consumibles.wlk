import wollok.game.*
import gameObjects.*
import gameEngine.*
import vectores.*
import proyectiles.*


class Consumible inherits GameObject {
	override method initialize() {
		super()
		gameEngine.consumibles().add(self)
		gameEngine.schedule(6000, { self.eliminar() }) // despues de 6 segundos desaparece
		// implementar blinking effect cuando esté por desaparecer  
	}
	override method height() = 30/registry.get("casillas_pixeles") 
	override method width() = 30/registry.get("casillas_pixeles")
	
	override method eliminar() {
		gameEngine.consumibles().remove(self)
		super()
	}
	
	method efectoSobre(jugador) {
		
	}

	override method resolverColisionCon(jugador) { // sabemos que solo peude colisionar con jugador
		self.efectoSobre(jugador)
		self.eliminar()
//		var puntajeJugador = jugador.puntaje()
//		puntajeJugador += puntajeJugador
	}
}


class Bebible inherits Consumible {
	override method resolverColisionCon(jugador) { // sabemos que solo peude colisionar con jugador
		super(jugador)
		sonidos.playSound("assets/SONIDOS/drinking.mp3", 1)
	}
}

class Comestible inherits Consumible {
	override method resolverColisionCon(jugador) { // sabemos que solo peude colisionar con jugador
		super(jugador)
		sonidos.playSound("assets/SONIDOS/eating.wav", 1)
	}
}


class Cereza inherits Comestible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/cereza.png"
	override method efectoSobre(jugador) {
		super(jugador)
		jugador.sumarVida(2)
	}
}


class SlimeBucket inherits Bebible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/slimebucket.png"
	override method efectoSobre(jugador) {
		super(jugador)
		jugador.activarTipoProyectil(elastico)
	}
}
class LavaBucket inherits Bebible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/lavabucket.png"
	override method efectoSobre(jugador) {
		super(jugador)
		jugador.activarTipoProyectil(magma)
	}
}
class SnowBucket inherits Bebible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/snowbucket.png"
	override method efectoSobre(jugador) {
		super(jugador)
		jugador.activarTipoProyectil(criogenico)
	}
}
class Coffee inherits Bebible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/coffee.png"
	override method efectoSobre(jugador) {
		super(jugador)
		jugador.activarHiperactividad()
	}
}



//class CartelPoderes inherits GameObject {
//	override method initialize() {
//		super()
//		gameEngine.schedule(10000, {self.eliminar()}) 
//	}
//}

//class Speed inherits CartelPoderes {
//	override method initialize() {
//		super()  
//	}
//	override method image() = "assets/cartelesPoderes/speed.png"
//}
//class Regeneration inherits CartelPoderes {
//	override method initialize() {
//		super()  
//	}
//	override method image() = "assets/cartelesPoderes/regeneration.png"
//}