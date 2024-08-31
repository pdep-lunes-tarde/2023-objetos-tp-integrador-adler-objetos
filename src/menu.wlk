import wollok.game.*
import tp.*
import gameEngine.*
import vectores.*
import mapa.*
import gameObjects.*
import ui.*

object menu {
	method iniciar() {
		const fondoNegro = new Imagen(x=0,y=0, image="assets/fondonegro.png")
		const titulo = new Imagen(x=70, y=120, image="assets/tituloPacman.png")
		const explicaciones = new Imagen(x=20, y=30, image="assets/explicaciones.png")
	  	
	  	sonidos.startMusic()

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


