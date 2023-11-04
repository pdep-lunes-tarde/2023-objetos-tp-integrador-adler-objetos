import wollok.game.*
import tp.*
import gameEngine.*
import vectores.*
import mapa.*
import gameObjects.*
import ui.*

object menu {
	const property musica = game.sound("assets/musica.mp3")
	
	method iniciar() {
		const fondoNegro = new ObjetosMenu(position= game.origin(), image="assets/fondonegro.png")
		const titulo = new ObjetosMenu(position= game.at(70,120), image="assets/tituloPacman.png")
		const explicaciones = new ObjetosMenu(position= game.at(20,30), image="assets/explicaciones.png")
	  	
		musica.shouldLoop(true)
		musica.volume(0.1)
		game.schedule(500, { musica.play()} )
		

	  	// PRESIONAR ENTER PARA EMPEZAR EL JUEGO
	  	keyboard.enter().onPressDo {
	  		game.clear() // limpia todo
	  		tp.jugar()   // empieza el juego en sí
		}
	}
	method mostrar() {
		game.start()
	}
}

class ObjetosMenu {
	var property image
	var property position
	
	override method initialize() {
		super()
		game.addVisual(self)
	}
}


