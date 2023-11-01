import wollok.game.*
import menu.*
import global.*
import vectores.*
import mapa.*
import gameObjects.*

/* Acá vamos a diseñar el menu de entrada para el juego */

object tp {
	method iniciar(width, height, title, pixeles){
		// iniciar ventana
		game.width(width/pixeles) // nro de celdas
	  	game.height(height/pixeles) 
	  	game.cellSize(pixeles) // fijado a 1 píxel
	  	game.title(title)
	  	game.ground("assets/background.png")
	  	
	  	// guardo valores globales
	  	const grid_width = width/pixeles
	  	const grid_height = height/pixeles
	  	const centro = vector.at(grid_width/2, grid_height/2)
	  	registry.put("grid_width", grid_width) // ancho (numero de celdas) de la grilla 
	  	registry.put("grid_height", grid_height)
	  	registry.put("casillas_pixeles", pixeles)
	  	registry.put("centro", centro)
	}
	method mostrarMenu() {
		menu.iniciar()
	  	menu.mostrar()
	}
	method jugar() { // empezar a jugar
		mapa.iniciar()
		// empezar el actualizador global
		updater.start()
	}
}

