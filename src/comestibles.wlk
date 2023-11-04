import wollok.game.*
import gameObjects.*
import gameEngine.*
import vectores.*
import proyectiles.*


class Comestible inherits GameObject {
	override method initialize() {
		super()
		gameEngine.comestibles().add(self)
		gameEngine.schedule(6000, { self.eliminar() }) // despues de 10 segundos desaparece
		// implementar blinking effect cuando esté por desaparecer  
	}
	override method height() = 30/registry.get("casillas_pixeles") 
	override method width() = 30/registry.get("casillas_pixeles")
	
	override method eliminar() {
		gameEngine.comestibles().remove(self)
		super()
	}
	 
	method efectoSobre(jugador) {
		game.say(jugador, "ñam ñam")
		
	}
	
	override method resolverColisionCon(jugador) { // sabemos que solo peude colisionar con jugador
		self.efectoSobre(jugador)
		self.eliminar()
	}
}

class SlimeBucket inherits Comestible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/slimebucket.png"
	override method efectoSobre(jugador) {
		super(jugador)
		jugador.activarTipoProyectil(elastico)
	}
}
class LavaBucket inherits Comestible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/lavabucket.png"
	override method efectoSobre(jugador) {
		super(jugador)
		jugador.activarTipoProyectil(magma)
	}
}
class SnowBucket inherits Comestible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/snowbucket.png"
	override method efectoSobre(jugador) {
		super(jugador)
		jugador.activarTipoProyectil(criogenico)
	}
	
}
class Coffee inherits Comestible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/coffee.png"
	override method efectoSobre(jugador) {
		super(jugador)
		jugador.activarHiperactividad()
	}
}



class CartelPoderes inherits GameObject {
	override method initialize() {
		super()
		gameEngine.schedule(10000, {self.eliminar()}) 
	}
}

class Speed inherits CartelPoderes {
	override method initialize() {
		super()  
	}
	override method image() = "assets/cartelesPoderes/speed.png"
}
class Regeneration inherits CartelPoderes {
	override method initialize() {
		super()  
	}
	override method image() = "assets/cartelesPoderes/regeneration.png"
}