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
	 	
	 	const cafe = new Coffee()



		// Aproximacion del Seno con un polinomio de mclaurin de orden 10
	  	const seno_Pol_mclaur_O10 = { x => 
	  		return x-((x**3)/6)+((x**5)/120)-((x**7)/5040)+((x**9)/362880)
	  	}
	  	const coseno = {x => 
	  		const a = 90 - x 
	  		return seno_Pol_mclaur_O10.apply(a)
	  	}
	  	


	  	const maximoBolitas = 20
	  	var cantidadBolitas = 0
	  	
    	game.onTick(2000, "crearBolitas", {
    		if(cantidadBolitas < maximoBolitas){
    			1.times { n =>
            		const randomX = (60..200).anyOne()
            		const randomY = (30..100).anyOne()
            		const bolita = new Bolita(x0 = randomX, y0 = randomY)
            		cantidadBolitas++
        		}	
    		}
    	})
    	
    	const maximofantasmas = 2
	  	var cantidadfantasmas = 0
	  	
    	game.onTick(1000, "crearFantasmnas", {
				if(cantidadfantasmas < maximofantasmas){
					1.times { n =>
						const vel = 1.randomUpTo(5)
						const fantasma = new Fantasma(x0=game.center().x()-1 + n*3, y0=game.center().y()+65, vel_x0=1, hayFriccion=false)
							game.onTick(1, "aceleracion radial", {
								const aceleracionRadial = (registry.get("centro") - fantasma.position()).versor()*0.1
								fantasma.accelerate(aceleracionRadial)
							})
						cantidadfantasmas++
					}
				}
			}		
		)
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







