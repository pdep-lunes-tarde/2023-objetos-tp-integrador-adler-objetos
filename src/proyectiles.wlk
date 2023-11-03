import gameObjects.*
import global.*
import wollok.game.*


class Proyectil inherits VerletObject{
	method tipo()
	override method initialize() {
		super()
		game.schedule(5000, {self.eliminar()}) 
	}
	override method height() = 30/registry.get("casillas_pixeles") 
	override method width() = 30/registry.get("casillas_pixeles")
	
	override method image() = self.tipo().image()
	
	override method update() {
		self.updatePosition(1) 
	}
}
class ProyectilJugador inherits Proyectil {
	override method tipo() = elastico
	override method initialize() {
		super()
	}
}
class ProyectilEnemigo inherits Proyectil {
	override method tipo() = fuego
	override method initialize() {
		super()
	}
}

// tipos de proyectiles
object magma {
	method image() = "assets/PROYECTIL/magmaball.png"
}
object elastico {
	method image() = "assets/PROYECTIL/slimeball.png"
}
object criogenico {
	method image() = "assets/PROYECTIL/snowball.png"
}
object fuego {
	method image() = "assets/PROYECTIL/fireball.png"
}

