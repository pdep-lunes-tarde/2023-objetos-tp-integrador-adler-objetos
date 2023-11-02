import gameObjects.*
import global.*


class Proyectil inherits VerletObject{
	override method initialize() {
		super()
	}
	override method height() = 30/registry.get("casillas_pixeles") 
	override method width() = 30/registry.get("casillas_pixeles")
}
class ProyectilJugador inherits Proyectil {
	override method initialize() {
		super()
	}
	override method image() = "assets/PROYECTIL/magmaball.png"
}
class ProyectilEnemigo inherits Proyectil {
	override method initialize() {
		super()
	}
	override method image() = "assets/PROYECTIL/fireball.png"
}

class Bolita inherits GameObject {
	
	override method initialize() {
    	super()
    }
    override method resolverColisionCon(objeto, vectorColision){
    	super(objeto, vectorColision)
    	if(objeto == self){
			objeto.eliminar()  
    	}
    }
	override method image() = "assets/bolita.png"
}