import wollok.game.*
import tp.*

/* Acá vamos a diseñar el menu de entrada para el juego */

object menu {
	method iniciar(width, height, pixeles){
	  	game.addVisual(titulo)
	  	const txt = new Texto(
	  		text="Presiona q para comenzar el juego",
	  		x=width/pixeles/2,
	  		y=height/pixeles/2,
	  		textColor="#F3FF00"
	  	)
	  	game.addVisual(txt)
	  	
	  	// PRESIONAR Q PARA EMPEZAR EL JUEGO
	  	keyboard.q().onPressDo {
	  		game.removeVisual(titulo)
	  		game.removeVisual(txt)
	  		tpIntegrador.iniciar(1200, 900, "PAC-MAN 2: ", 5)
			tpIntegrador.jugar()	
		}
	}
	
}

object titulo {
	var property position = game.center()	

	method image() = "assets/cereza.png"

}

class Texto {
	const x 
	const y 
	const property text
	const property textColor
	method position() = game.at(x,y)
}
