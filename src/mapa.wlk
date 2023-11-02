import global.*
import vectores.*
import gameObjects.*
import wollok.game.*
import menu.*
import pacman.Pacman
import enemigos.*
import proyectiles.*

object mapa {	
	method iniciar() { // acá agregamos los objetos del juego
		const jugador = new Pacman() 		
//		const bolita = new Bolita(x0=100, y0= 100)
//		const puntaje = new TextoPuntaje(x0=200, y0= 200)
		
		// Aproximacion del Seno con un polinomio de mclaurin de orden 10
	  	const seno_Pol_mclaur_O10 = { x => 
	  		return x-((x**3)/6)+((x**5)/120)-((x**7)/5040)+((x**9)/362880)
	  	}
	  	const coseno = {x => 
	  		const a = 90 - x 
	  		return seno_Pol_mclaur_O10.apply(a)
	  	}
	  	
//	  	const proyectilJugador = new ProyectilJugador()
//	  	const proyectilEnemigo = new ProyectilEnemigo()
	  	
		// fantasmas normales 
//		2.times { n =>
//			const fantasma = new Fantasma()
//		}
	}
}



class TextoPuntaje{
	const text = "Puntaje: "
	const textColor = "#FFFFF"
	method position() = game.at(0,0)
	
	override method initialize() {
    	super()
    }
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







