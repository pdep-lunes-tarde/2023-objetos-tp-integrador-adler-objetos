import wollok.game.*
import gameObjects.*
import global.*
import vectores.*
import proyectiles.*


class Comestible inherits GameObject {
	override method initialize() {
		super()
		game.schedule(6000, {if(not self.inhabilitado()){self.eliminar()}}) // despues de 10 segundos desaparece
		// implementar blinking effect cuando esté por desaparecer  
	}
	override method height() = 30/registry.get("casillas_pixeles") 
	override method width() = 30/registry.get("casillas_pixeles")
	
	method comer() {
		self.eliminar()
	}
	method efecto(jugador) {
		console.println(jugador.toString()+": ñam ñam")
	}
}

class SlimeBucket inherits Comestible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/slimebucket.png"
	override method efecto(jugador) {
		super()
	}
}
class LavaBucket inherits Comestible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/lavabucket.png"
	override method efecto(jugador) {
		super()
	}
}
class SnowBucket inherits Comestible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/snowbucket.png"
	override method efecto(jugador) {
		super()
	}
	
}
class Coffee inherits Comestible {
	override method initialize() {
		super()  
	}
	override method image() = "assets/COMESTIBLES/coffee.png"
	override method efecto(jugador) {
		super()
	}
}



class CartelPoderes inherits GameObject {
	override method initialize() {
		super()
		game.schedule(10000, {self.eliminar()}) 
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