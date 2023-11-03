import gameObjects.*
import global.*
import wollok.game.*
import colisiones.*


class Proyectil inherits VerletObject{
	var contadorTiempoEnVida = 0
	method tiempoDeVida() = 5000 // no se q unidad de tiempo es
	method tipo()
	
	override method initialize() {
		super()
		game.schedule(self.tiempoDeVida(), {if(not self.inhabilitado()) {self.eliminar()}})
		
	}
	override method height() = 30/registry.get("casillas_pixeles") 
	override method width() = 30/registry.get("casillas_pixeles")
	
	override method image() = self.tipo().image()
	
	override method update(dt) {
		super(dt)
		self.updatePosition(dt) 
	}
	override method resolverColisionCon(objeto) {
		console.println("Proyectil chocó "+objeto.toString())
		self.eliminar()
		self.tipo().efectosSobre(objeto)
	}
}
class ProyectilJugador inherits Proyectil {
	override method tipo() = magma
	override method initialize() {
		super()
		gameObjects.proyectilesJugador().add(self)
	}
	override method eliminar() {
		super()
		gameObjects.proyectilesJugador().remove(self)
	}
	
}
class ProyectilEnemigo inherits Proyectil {
	override method tipo() = fuego
	override method initialize() {
		super()
		gameObjects.proyectilesEnemigos().add(self)
	}
	override method eliminar() {
		super()
		gameObjects.proyectilesEnemigos().remove(self)
	}

}
class TipoDeProyectil {
	method image()
	method efectosSobre(objeto) {
		objeto.morir()
	}
}
// tipos de proyectiles
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