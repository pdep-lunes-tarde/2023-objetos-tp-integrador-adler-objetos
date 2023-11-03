import wollok.game.*
import gameObjects.*
import global.*
import vectores.*
import proyectiles.*

class Comestible inherits GameObject {
	override method initialize() {
		super()
		game.schedule(10000, {self.eliminar()}) // despues de 10 segundos desaparece
		// implementar blinking effect cuando esté por desaparecer  
	}
	override method height() = 30/registry.get("casillas_pixeles") 
	override method width() = 30/registry.get("casillas_pixeles")
	
	method efecto(jugador)
}

class SlimeBucket inherits Comestible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/slimebucket.png"
	override method efecto(jugador) {
	}
}
class LavaBucket inherits Comestible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/lavabucket.png"
	override method efecto(jugador) {
		
	}
}
class SnowBucket inherits Comestible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/snowbucket.png"
	
}
class Coffee inherits Comestible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/coffee.png"
	override method efecto(jugador) {
		
	}
}