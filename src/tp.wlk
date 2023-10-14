import wollok.game.*

import global.*
import vectores.*
import gameObjects.*
import colisiones.*
import mapa.*


object tpIntegrador {
	method jugar() {
		game.start()
	}
	method iniciar(width, height, title, pixeles) {
		// iniciar ventana
		game.width(width/pixeles) // nro de celdas
	  	game.height(height/pixeles) 
	  	game.cellSize(pixeles) // fijado a 1 píxel
	  	game.title(title)
	  	game.ground("assets/background.png")
	  	
	  	// guardo valores globales
	  	registry.put("grid_width", width/pixeles) // ancho (numero de celdas) de la grilla 
	  	registry.put("grid_height", height/pixeles)
	  	registry.put("casillas_pixeles", pixeles)
	  	
	  	registry.put("centro", vector.at(width/pixeles/2, height/pixeles/2))
	  	
	  	
	  	// agregar visuales
	  	
	  	const sine_Pol_mclaur_O10 = { x => 
	  		return x-((x**3)/6)+((x**5)/120)-((x**7)/5040)+((x**9)/362880)
	  	}
	  	const cosine = {x => 
	  		const a = 90 - x
	  		return sine_Pol_mclaur_O10.apply(a)
	  	}
	  	
		3.times { n =>
			new Fantasma(x0=game.center().x(), y0=game.center().y())
		}

//		(0..0).forEach { n => 
//			const obstaculo = new GameObject(x=n,y=n)
//			(new FrameDeColision(objetoAsociado=obstaculo)).agregarPerimetro(
//				new Rectangulo(altura=obstaculo.spriteHeight(), ancho=obstaculo.spriteWidth()), 
//				vector.at(0,0)
//			)
//		}
	  	
		// empezar el actualizador global
		updater.start()
		
		// teclado
		keyboard.w().onPressDo { 
			jugador.arriba()
		}
		keyboard.a().onPressDo { 
			jugador.izquierda()
		}
		keyboard.s().onPressDo { 
			jugador.abajo()
		}
		keyboard.d().onPressDo { 
			jugador.derecha()
		}
		keyboard.q().onPressDo {
			game.stop()
		}
		keyboard.t().onPressDo {
			console.println(jugador.toString()+": rapidez = "+jugador.rapidez())
			jugador.tp(jugador.x0(), jugador.y0())
		}
		keyboard.r().onPressDo { // reiniciar su posicion, con velocidad 0
			jugador.reiniciar()
			
		}
		
		
//		keyboard.t().onPressDo {
//			colisiones.toggleColisiones()
//		}
		
//		game.whenCollideDo(pacman, {x => 
//			game.say(pacman, "choque a " + x.identity())
//		})
	}	
}