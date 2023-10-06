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
	  	game.ground("assets/400 puntos.png")
	  	
	  	// guardo valores globales
	  	registry.put("window_width", width/pixeles)
	  	registry.put("window_height", height/pixeles)
	  	
	  	// agregar visuales
	  	const pacman = new Pacman()
	  	registry.put("pacman", pacman) // lo guardo para poder acceder en los tests
	  	game.addVisual(pacman) // el uso de addVisualCharacter o addVisual para el personaje es indiferente, utilizamos teclas "wasd"
	  	game.addVisual(new GameObject(x=1,y=1))
	  	
	  	const hitbox = new FrameDeColision(objetoAsociado=pacman)
	  	hitbox.agregarPerimetro(
			new Rectangulo(altura=96/pixeles, ancho=96/pixeles), 
			vector.at(0,0)
		)
	  	
		// empezar el actualizador global
		updater.add(pacman)
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
		
		//game.whenCollideDo(pacman, {x => game.say(pacman, "choque a " + x.toString())})    
	}	
}