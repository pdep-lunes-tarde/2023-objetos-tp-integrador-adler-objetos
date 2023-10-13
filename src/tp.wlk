import wollok.game.*

import global.*
import vectores.*
import gameObjects.*
import colisiones.*



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
	  	registry.put("window_width", width/pixeles)
	  	registry.put("window_height", height/pixeles)
	  	registry.put("casillas_pixeles", pixeles)
	  	registry.put("coef", pixeles/45) // 45 es el tamaño en pixeles
	  	
	  	
	  	// agregar visuales
	  	
	  	
		(1..2).forEach { n =>
			new Fantasma(x0=n*5, y0=100)
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
//		keyboard.t().onPressDo {
//			colisiones.toggleColisiones()
//		}
		
//		game.whenCollideDo(pacman, {x => 
//			game.say(pacman, "choque a " + x.identity())
//		})
	}	
}