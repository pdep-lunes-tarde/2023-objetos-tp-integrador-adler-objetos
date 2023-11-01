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

object menu {
	method iniciar() {
		//Agrego fondo y titulo del menu	  	
		game.addVisual(fondoNegro)
	  	game.addVisual(titulo)
	  	const centro = registry.get("centro")
	  	const txt = new Texto(
	  		text="Presiona m para comenzar el juego",
	  		x=centro.x(),
	  		y=centro.y(),
	  		textColor="#FFFFFF"
	  	)
	  	game.addVisual(txt)
	  	
	  	const musica = game.sound("assets/musica.mp3")
		musica.shouldLoop(true)
		game.schedule(500, { musica.play()} )
	  	
	  	// PRESIONAR M PARA EMPEZAR EL JUEGO
	  	keyboard.m().onPressDo {
	  		game.removeVisual(titulo)
	  		game.removeVisual(txt)
	  		game.removeVisual(fondoNegro)
	  		tp.jugar()
		}
	}
	method mostrar() {
		game.start()
	}
}

object titulo {
	var property position = game.at(70,100)	

	method image() = "assets/tituloPacman.png"

}

object fondoNegro {
    var property position = game.origin()
    
    method image() = "assets/fondonegro.png"
}


class Texto {
	const x 
	const y 
	const property text
	const property textColor
	method position() = game.at(x,y)
}
