import wollok.game.*
import gameEngine.*
import enemigos.*
import gameObjects.*
import proyectiles.*
import tp.*
import mapa.*


object teclas {
	method iniciar() {
		self.teclasGenerales()
		self.teclasFantasmas()
		self.teclasJugador()
	}
	method teclasGenerales() {
		keyboard.q().onPressDo {
			game.stop()
		}
		keyboard.c().onPressDo {
			updater.toggleCamaraLenta()
		}
		keyboard.h().onPressDo {
			gameEngine.jugador().activarHiperactividad()
		}
	}
	method teclasFantasmas() {
		keyboard.f().onPressDo { // spawnear más fantasmas giratorios
			mapa.spawnearFantasmas(1)
		}
	}
	method teclasJugador() {
		const jugador = gameEngine.jugador()
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
