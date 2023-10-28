import wollok.game.*

import global.*
import vectores.*
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
	  	registry.put("centro", vector.at(((width/pixeles))/2, ((height/pixeles))/2))
	  	
	  	
	  	
	  	mapa.iniciar()


		// empezar el actualizador global
		updater.start()
	}	
}