import global.*
import vectores.*
import gameObjects.*
import wollok.game.*
import menu.*
import pacman.Pacman
import enemigos.*
import proyectiles.*
import comestibles.*

object mapa {	
	method iniciar() { // acá agregamos los objetos del juego
		const jugador = new Pacman() 

		2.times { n =>
		 	const fantasma = new Fantasma(x0=game.center().x()-1 + n*3, y0=game.center().y()+65, hayFriccion=true)
	 	}

		// Aproximacion del Seno con un polinomio de mclaurin de orden 10
	  	const seno_Pol_mclaur_O10 = { x => 
	  		return x-((x**3)/6)+((x**5)/120)-((x**7)/5040)+((x**9)/362880)
	  	}
	  	const coseno = {x => 
	  		const a = 90 - x 
	  		return seno_Pol_mclaur_O10.apply(a)
	  	}
	  	
    	game.onTick(12000, "crearCafes", {
    		1.times { n =>
            	const randomX = (60..180).anyOne()
            	const randomY = (30..100).anyOne()
            	const cafe = new Coffee(x0 = randomX, y0 = randomY)
        	}	
    	})
    	
    	game.onTick(25000, "crearLavaBuckets", {
    		1.times { n =>
            	const randomX = (60..180).anyOne()
            	const randomY = (30..100).anyOne()
            	const lavaBucket = new LavaBucket(x0 = randomX, y0 = randomY)
        	}	
    	})
//    	
//    	const maximofantasmas = 2
//	  	var cantidadfantasmas = 0
//	  	
//    	game.onTick(1000, "crearFantasmnas", {
//				if(cantidadfantasmas < maximofantasmas){
//					1.times { n =>
//						const vel = 1.randomUpTo(5)
//						const fantasma = new Fantasma(x0=game.center().x()-1 + n*3, y0=game.center().y()+65, vel_x0=1, hayFriccion=false)
//							game.onTick(1, "aceleracion radial", {
//								const aceleracionRadial = (registry.get("centro") - fantasma.position()).versor()*0.1
//								fantasma.accelerate(aceleracionRadial)
//							})
//						cantidadfantasmas++
//					}
//				}
//			}		
//		)
	}
}


class Circulo {
	const property position = registry.get("centro") - vector.at(800/2/20,800/2/20)
	method image() = "assets/circulo150.png"
	
}








