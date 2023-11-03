import wollok.game.*
import tp.*
import global.*
import vectores.*
import mapa.*
import gameObjects.*
import ui.*

object menu {
	const property musica = game.sound("assets/musica.mp3")
	
	method iniciar() {
		//Agrego fondo y titulo del menu	  	
		game.addVisual(fondoNegro)
	  	game.addVisual(titulo)
	  	const centro = registry.get("centro")
	  	game.addVisual( new Texto(
	  		text="Presiona E para comenzar el juego",
	  		x=centro.x()-6,
	  		y=centro.y(),
	  		textColor="#FFFFFF"
	  	))
	  	
		musica.shouldLoop(true)
		musica.volume(0.1)
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



