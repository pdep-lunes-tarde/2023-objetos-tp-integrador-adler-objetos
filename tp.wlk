import wollok.game.*
import menu.*
import gameEngine.*
import vectores.*
import mapa.*
import gameObjects.*
import teclas.*
import ui.*

/* Acá vamos a diseñar el menu de entrada para el juego */

object tp {
	method iniciar(width, height, title, pixeles){
		
		game.width(width/pixeles) 
	  	game.height(height/pixeles) 
	  	game.cellSize(pixeles) 
	  	game.title(title)
	  	game.ground("assets/background.png")
	  	
	  	
	  	const grid_width = width/pixeles
	  	const grid_height = height/pixeles
	  	const centro = vector.at(grid_width/2, grid_height/2)
	  	registry.put("grid_width", grid_width) 
	  	registry.put("grid_height", grid_height)
	  	registry.put("casillas_pixeles", pixeles)
	  	registry.put("centro", centro)
	}
	method mostrarMenu() {
		menu.iniciar()
	  	menu.mostrar()
	}
	method jugar() { 
		updater.start(1) 
		mapa.iniciar()
		ui.iniciar()
		teclas.iniciar()
		
	}
}

