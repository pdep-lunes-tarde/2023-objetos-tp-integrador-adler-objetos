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
	  	game.ground("assets/null.png")
	  	
	  	// guardo valores globales
	  	registry.put("window_width", width/pixeles)
	  	registry.put("window_height", height/pixeles)
	  	registry.put("casillas_pixeles", pixeles)
	  	
	  	// agregar visuales
	  	const pacman = new Pacman()
	  	registry.put("pacman", pacman) // lo guardo para poder acceder en los tests
	  	

		// con 100 va bien
		// con 500 se lagea
		(0..0).forEach { n => 
			const obstaculo = new GameObject(x=n,y=n)
			(new FrameDeColision(objetoAsociado=obstaculo)).agregarPerimetro(
				new Rectangulo(altura=obstaculo.spriteHeight(), ancho=obstaculo.spriteWidth()), 
				vector.at(0,0)
			)
		}
		
		const obstaculo1 = new GameObject(x=1,y=1)
		(new FrameDeColision(objetoAsociado=obstaculo1)).agregarPerimetro(
			new Rectangulo(altura=obstaculo1.spriteHeight(), ancho=obstaculo1.spriteWidth()), 
			vector.at(0,0)
		)
		const obstaculo2 = new GameObject(x=2,y=2)
		(new FrameDeColision(objetoAsociado=obstaculo2)).agregarPerimetro(
			new Rectangulo(altura=obstaculo2.spriteHeight(), ancho=obstaculo2.spriteWidth()), 
			vector.at(0,0)
		)
	  	
		// empezar el actualizador global
		updater.start()
		
		// teclado
		keyboard.w().onPressDo { 
			pacman.arriba()
		}
		keyboard.a().onPressDo { 
			pacman.izquierda()
		}
		keyboard.s().onPressDo { 
			pacman.abajo()
		}
		keyboard.d().onPressDo { 
			pacman.derecha()
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