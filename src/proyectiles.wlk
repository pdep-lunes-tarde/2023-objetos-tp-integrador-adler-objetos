import gameObjects.*
import gameEngine.*
import wollok.game.*
import colisiones.*


class Proyectil inherits VerletObject{
	const tipo // debe ser definido
	
	var contadorTiempoEnVida = 0
	method tiempoDeVida() = 5000
	
	override method initialize() {
		super()
		gameEngine.schedule(self.tiempoDeVida(), {self.eliminar()})
	}
	override method height() = 30/registry.get("casillas_pixeles") 
	override method width() = 30/registry.get("casillas_pixeles")
	
	override method image() = tipo.image()
	
	override method update(dt) {
		super(dt)
		self.updatePosition(dt) 
	}
	override method resolverColisionCon(objeto) {
		console.println("Proyectil chocó "+objeto.toString())
		self.eliminar()
		tipo.efectosSobre(objeto)
	}
}
class ProyectilJugador inherits Proyectil {
	override method initialize() {
		super()
		gameEngine.proyectilesJugador().add(self)
	}
	override method eliminar() {
		super()
		gameEngine.proyectilesJugador().remove(self)
	}
	
}
class ProyectilEnemigo inherits Proyectil {
	override method initialize() {
		super()
		gameEngine.proyectilesEnemigos().add(self)
	}
	override method eliminar() {
		super()
		gameEngine.proyectilesEnemigos().remove(self)
	}

}

// tipos de proyectiles
class TipoDeProyectil {
	method image()
	method efectosSobre(objeto) {
		objeto.restarVida(1)
	}
}
object piedra inherits TipoDeProyectil {
	override method image() = "assets/PROYECTIL/flint.png"
	override method efectosSobre(objeto) {
		super(objeto)
	}
}
object magma inherits TipoDeProyectil {
	override method image() = "assets/PROYECTIL/magmaball.png"
	override method efectosSobre(objeto) {
		super(objeto)
	}
}
object elastico inherits TipoDeProyectil {
	override method image() = "assets/PROYECTIL/slimeball.png"
	override method efectosSobre(objeto) {
		super(objeto)
	}
}
object criogenico inherits TipoDeProyectil {
	override method image() = "assets/PROYECTIL/snowball.png"
	override method efectosSobre(objeto) {
		super(objeto)
	}
}
object fuego inherits TipoDeProyectil {
	override method image() = "assets/PROYECTIL/fireball.png"
	override method efectosSobre(objeto) {
		super(objeto)
	}
}