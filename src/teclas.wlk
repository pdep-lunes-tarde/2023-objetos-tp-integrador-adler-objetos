import wollok.game.*
import gameEngine.*
import enemigos.*
import gameObjects.*
import proyectiles.*


object teclas {
	method iniciar() {
		self.teclasGlobales()
		self.teclasFantasmas()
		self.teclasJugador()
	}
	method teclasGlobales() {
		keyboard.q().onPressDo {
			game.stop()
		}
		keyboard.c().onPressDo {
			updater.toggleCamaraLenta()
		}
	}
	method teclasFantasmas() {
		keyboard.f().onPressDo { // spawnear más fantasmas giratorios
			1.times { n =>
				const vel = 1.randomUpTo(5)
			 	const fantasma = new Fantasma(x0=game.center().x()-1 + n*3, y0=game.center().y()+65, hayFriccion=true)
//			 	game.onTick(1, "aceleracion radial", {
//			 		const aceleracionRadial = (registry.get("centro") - fantasma.position()).versor()*0.1
//			 		fantasma.accelerate(aceleracionRadial)
//			 	})
		 	}
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
