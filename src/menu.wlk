import wollok.game.*
import tp.*
import global.*
import vectores.*
import mapa.*
import gameObjects.*

/* Acá vamos a diseñar el menu de entrada para el juego */

object men {
	method mostrarMenu() {
		const musica = game.sound("assets/musica.mp3")
		musica.shouldLoop(true)
		game.schedule(500, { musica.play()} )
		game.start()
	}
	method iniciar(width, height, title, pixeles){
		
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
	  	
	  	//Agrego fondo y titulo del menu	  	
		game.addVisual(fondoNegro)
	  	game.addVisual(titulo)
	  	const txt = new Texto(
	  		text="Presiona m para comenzar el juego",
	  		x=width/pixeles/2,
	  		y=height/pixeles/2,
	  		textColor="#FFFFFF"
	  	)
	  	game.addVisual(txt)
	  	
	  	// PRESIONAR M PARA EMPEZAR EL JUEGO
	  	keyboard.m().onPressDo {
	  		game.removeVisual(titulo)
	  		game.removeVisual(txt)
	  		game.removeVisual(fondoNegro)
	  		self.jugar()
		}
		
		
	}
	method jugar() { // empezar a jugar
		mapa.iniciar()
		// empezar el actualizador global
		updater.start()
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
