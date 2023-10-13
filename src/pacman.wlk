import wollok.game.*

import global.*
import vectores.*
import colisiones.*
import gameObjects.*


object pacman inherits VerletObject {
	const property magnitud_fuerza = 15 / registry.get("casillas_pixeles")
	
	var orientacion = "der"
	var animacionEstado = "cerrado"
	var aux = "cerrado"+"-"+orientacion
	
	const masa = 1
	
	override method image() = "assets/PACMAN/"+aux+".png"
	
	/* PARA LAS COLISIONES. 
	 * DIVIDIR LA PANTALLA EN VARIAS CELDAS, DEBEN SER MAS GRANDES QUE LAS DE WOLLOK
	 * LLEVAR REGISTRO INDIVIDUAL DE LAS CELDAS QUE OCUPA CADA GAMEOBJECT
	 * SI OTRO GAMEOBJECT COMPARTE ALGUNA CELDA SIMULTANEAMENTE CON EL JUGADOR...
	 * ENTONCES, VERIFICAMOS SI EN ESA CELDA SE DA REALMENTE UNA COLISION. 
	 * 
	 * */
	
	override method initialize() {
		super()
		
//		game.whenCollideDo(self, {x => 
//			frameDeColision.forEach { ptoColision => 
//				if (not (x === ptoColision)) {
//					game.say(self, "Choque a " + x.identity())
//				} 
//			}	
//		})
		
		game.onTick(80, "animacion-pacman", { 
			if(animacionEstado == "abierto") {
				animacionEstado = "medio"
				aux = animacionEstado+"-"+orientacion
			} 
			else if(animacionEstado == "medio") {
				animacionEstado = "cerrado"
				aux = animacionEstado 
			} 
			else {
				animacionEstado = "abierto"
				aux = animacionEstado+"-"+orientacion
			}
		})
	}
	 
	
	// crean el efecto de que alguien los tira hacia el sentido indicado
	method arriba() {
		self.accelerate(0, magnitud_fuerza * masa)							
		orientacion = "arriba"
	}
	method abajo() {
		self.accelerate(0, -magnitud_fuerza * masa)		
		orientacion = "abajo"						
	}
	method derecha() {
		self.accelerate(magnitud_fuerza * masa, 0)		
		orientacion = "der"						
	}
	method izquierda() {
		self.accelerate(-magnitud_fuerza * masa, 0)
		orientacion = "izq"							
	}
}
