import wollok.game.*
import tp.*
import global.*
import vectores.*
import mapa.*
import gameObjects.*
import ui.*

object menu {
	method iniciar() {
		//Agrego fondo y titulo del menu	  	
		game.addVisual(fondoNegro)
	  	game.addVisual(titulo)
	  	const centro = registry.get("centro")
	  	game.addVisual( new Texto(
	  		text="Presiona m para comenzar el juego",
	  		x=centro.x(),
	  		y=centro.y(),
	  		textColor="#FFFFFF"
	  	))
	  	
	  	const musica = game.sound("assets/musica.mp3")
		musica.shouldLoop(true)
		game.schedule(500, { musica.play()} )

	  	// PRESIONAR E PARA EMPEZAR EL JUEGO
	  	keyboard.e().onPressDo {
	  		game.clear() // limpia todo
	  		tp.jugar()   // empieza el juego en sí
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



