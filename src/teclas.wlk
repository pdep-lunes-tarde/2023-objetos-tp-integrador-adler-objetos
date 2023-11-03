import wollok.game.*
import global.*
import enemigos.*
import gameObjects.*
import proyectiles.*


object teclas {
	method iniciar() {
		self.teclasGlobales()
		self.teclasJugador()
	}
	method teclasGlobales() {
		keyboard.q().onPressDo {
			game.stop()
		}
	}

	method teclasJugador() {
		const jugador = gameObjects.jugador()
		keyboard.w().onPressDo { 
			jugador.arriba()
		}
		keyboard.a().onPressDo { 
			jugador.izquierda()
		}
		keyboard.s().onPressDo { 
			jugador.abajo()
		}
		keyboard.d().onPressDo { 
			jugador.derecha()
		}
		keyboard.space().onPressDo {
			jugador.disparar()
		}
		keyboard.t().onPressDo {
			console.println(jugador.toString()+": rapidez = "+jugador.rapidez())
			jugador.tp(jugador.x0(), jugador.y0())
		}
		keyboard.r().onPressDo { // reiniciar su posicion, con velocidad 0
			jugador.reiniciar()	
		}
		keyboard.m().onPressDo { // matar al jugador
			jugador.morir()
		}
		keyboard.x().onPressDo { // deletear al jugador
			jugador.eliminar() // EXISTE MANERA DE BORRAR EL OBJETO DEL PROGRAMA Y NO SOLO DEL MAPA? 
		}
	}
}
