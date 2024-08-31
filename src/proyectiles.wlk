import gameObjects.*
import gameEngine.*
import wollok.game.*
import colisiones.*


class Proyectil inherits VerletObject{
	const tipo // debe ser definido
	
	var contadorTiempoEnVida = 0
	method tiempoDeVida()
		
	override method initialize() {
		super()
		gameEngine.schedule(self.tiempoDeVida(), {self.eliminar()})
	}
	override method height() = 30/registry.get("casillas_pixeles") 
	override method width() = 30/registry.get("casillas_pixeles")
	
	override method image() = tipo.image()
	
	method siSeSaleDeLasParedesSeElimina() {
		const piso = 0
		const techo = registry.get("grid_height") - self.height() // hay q tener en cuenta el tamaño del sprite,
		const derecha = registry.get("grid_width") - self.width() // ya que el pivot está en la esquina abajo-izquierda del sprite.
		const izquierda = 0
		
		// si se sale de las paredes entonces los borramos, para mejorar la performance
		if ((y < piso)or(x < izquierda)or(y > techo)or(x > derecha)) {
			self.eliminar()
		}
	}     
	
	override method update(dt) {
		self.siSeSaleDeLasParedesSeElimina()
		self.updatePosition(dt)
	}
	override method resolverColisionCon(objeto) {
		console.println("Proyectil chocó "+objeto.toString())
		self.eliminar()
		tipo.efectosSobre(objeto)
	}
}
class ProyectilJugador inherits Proyectil {
	override method tiempoDeVida() = 10000
	override method initialize() {
		super()
		gameEngine.proyectilesJugador().add(self)
	}
	override method eliminar() {
		super()
		gameEngine.proyectilesJugador().remove(self)
	}
	override method update(dt) {
		if (tipo == elastico) { // ya se que es poco objetoso :(
			self.applyWallConstraint()
		} else {
			self.siSeSaleDeLasParedesSeElimina()
		}
		self.updatePosition(dt)
	}
}
class ProyectilEnemigo inherits Proyectil {
	override method tiempoDeVida() = 7000
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
		gameEngine.say(objeto, "auch")
	}
}
object magma inherits TipoDeProyectil {
	override method image() = "assets/PROYECTIL/magmaball.png"
	override method efectosSobre(objeto) {
		objeto.restarVida(2)
	}
}
object elastico inherits TipoDeProyectil {
	override method image() = "assets/PROYECTIL/slimeball.png"
	override method efectosSobre(objeto) {
		super(objeto)
		sonidos.playSound("assets/SONIDOS/slime-hit.mp3", 1)
	}
	// puede rebotar 
}
object criogenico inherits TipoDeProyectil {
	override method image() = "assets/PROYECTIL/snowball.png"
	override method efectosSobre(objeto) {
		super(objeto)
		objeto.congelarUnRato()
	}
}
object fuego inherits TipoDeProyectil {
	override method image() = "assets/PROYECTIL/fireball.png"
	override method efectosSobre(objeto) {
		super(objeto)
		sonidos.playSound("assets/SONIDOS/fireout.mp3", 1)
	}
}