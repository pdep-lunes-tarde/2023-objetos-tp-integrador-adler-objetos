import wollok.game.*

import global.*
import vectores.*
import gameObjects.*



object tpIntegrador {
	method jugar() {
		game.start()
	}
	method iniciar(width, height, title) {
		// iniciar ventana
		game.width(width) // nro de celdas
	  	game.height(height) 
	  	game.cellSize(1) // fijado a 1 píxel
	  	game.title(title)
	  	game.boardGround("assets/background.png")
	  	
	  	// guardo valores globales
	  	registry.put("window_width", width)
	  	registry.put("window_height", height)
	  	
	  	// agregar visuales
	  	const pacman = new Pacman()
	  	registry.put("pacman", pacman) // lo guardo para poder acceder en los tests
	  	game.addVisual(pacman) // el uso de addVisualCharacter o addVisual para el personaje es indiferente, utilizamos teclas "wasd"
	  	game.addVisual(new GameObject(x=1,y=1))
	  	
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
		
		game.whenCollideDo(pacman, {x => game.say(pacman, "choque a " + x.toString())})
		game.whenCollideDo(pacman, {x => game.say(pacman, "choque a " + x.toString())})    
	}	
}