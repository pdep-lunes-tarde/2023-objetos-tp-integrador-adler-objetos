import wollok.game.*
import tp.*

/* Acá vamos a diseñar el menu de entrada para el juego */

object menu {
	method mostrarMenu() {
		game.start()
	}
	method iniciarMenu(width, height, title, pixeles){
		// iniciar ventana
		game.width(width/pixeles) // nro de celdas
	  	game.height(height/pixeles) 
	  	game.cellSize(pixeles) // fijado a 1 píxel
	  	game.title(title)
	  	game.boardGround("assets/background.png") 
	  	game.addVisual(titulo)
	  	
	  	keyboard.q().onPressDo {
			game.removeVisual(titulo)
	  		tpIntegrador.iniciar(1200, 900, "PAC-MAN 2", 5)
			tpIntegrador.jugar()
			
		}
	  
	}
	
}

object titulo {
	var property position = game.center()	

	method image() = "assets/cereza.png"

}

object texto {
	method position() = game.at(20,30)// Falta fijar bien la posicion para que se vea
	
	method text() = "Presiona q para comenzar el juego"
}
