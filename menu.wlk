import wollok.game.*
import tp.*
import gameEngine.*
import vectores.*
import mapa.*
import gameObjects.*
import ui.*

object menu {
	method iniciar() {
		const fondoNegro = new Imagen(x=0,y=0, image="assets/fondonegro.png", height=null, width=null)
		const titulo = new Imagen(x=70, y=120, image="assets/tituloPacman.png", height=null, width=null)
		const explicaciones = new Imagen(x=20, y=30, image="assets/explicaciones.png", height=null, width=null)

		sonidos.startMusic()

		
	  	keyboard.enter().onPressDo {
	  		game.clear() 
	  		tp.jugar()   
		}
	}
	method mostrar() {
		game.start()
	}
}


