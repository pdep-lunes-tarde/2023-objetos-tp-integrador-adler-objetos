import global.*
import vectores.*
import gameObjects.*
import wollok.game.*
import menu.*

object mapa {
	/*
	 * Diseñamos el nivel de los juegos 
	 * 
	 *  '5' -> pared --> en realidad es mejor que las paredes se generen alrededor de la comida
	 * 	'0' -> espacio vacio
	 *  '3' -> pacman
	 *  '9' -> fantasma
	 *  '2' -> comida
	 *  
	 */
	// cada elemento de esta lista representa un espacio de 45x45 (px) del juego
	// dado que la ventana es de 1125x900 px^2, la lista debe ser de 25x20 elementos
	const nivel1 = [
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,2,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,2,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,2,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,2,0,2,2,2,2,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,2,0,2,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,2,0,2,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	]	
	
	method iniciar() { // acá agregamos los objetos del juego
		const jugador = new Pacman() 		
		const bolita = new Bolita(x0=100, y0= 100)
		const puntaje = new TextoPuntaje(x0=200, y0= 200)
		
		// Aproximacion del Seno con un polinomio de mclaurin de orden 10
	  	const seno_Pol_mclaur_O10 = { x => 
	  		return x-((x**3)/6)+((x**5)/120)-((x**7)/5040)+((x**9)/362880)
	  	}
	  	const coseno = {x => 
	  		const a = 90 - x
	  		return seno_Pol_mclaur_O10.apply(a)
	  	}
	  	
//	  	const bolaDeFuego = new Proyectil(x0=game.center().x(), y0=game.center().y())
//	  	const a = new VerletObject()
//	  	const proyectil = new Proyectil()
	  	
		// fantasmas normales 
		2.times { n =>
			const fantasma = new Fantasma(jugador=jugador)
		}
		
		 // fantasmas haciendo MOA
//		 3.times { n =>
//		 	const fantasma = new Fantasma(jugador=jugador, x0=game.center().x()-1 + n*3, y0=game.center().y()+65, vel_x0=5, hayFriccion=false)
//		 	game.onTick(1, "aceleracion radial", {
//		 		const aceleracionRadial = (registry.get("centro") - fantasma.position()) / 10
//		 		fantasma.accelerate(aceleracionRadial) // acelerar hacia el centro. Aceleracion radial.
//		 	})
//		 	// el fantasma necesita velocidad inicial suficiente para ponerse en orbita y seguir un MOA.
//		 }
	}
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

class TextoPuntaje inherits GameObject{
	const text = "Puntaje: "
	const textColor = "#FFFFF"
	method position() = game.at(x,y)
	
	override method initialize() {
    	super()
    }
}

class Proyectil inherits VerletObject{
	override method initialize() {
		super()
	}
	override method image() = "assets/PROYECTIL/fireball.png"
}

class Circulo {
	const property position = registry.get("centro") - vector.at(800/2/20,800/2/20)
	method image() = "assets/circulo150.png"
	
}

class Pelota inherits VerletObject {
	override method initialize() {
		super()
	}
	override method image() = "assets/PACMAN/cerrado.png"
}







