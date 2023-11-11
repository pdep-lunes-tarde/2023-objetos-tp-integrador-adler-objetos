import gameEngine.*
import wollok.game.*
import proyectiles.*
import gameObjects.*
import menu.*

object ui {
	const property displayCorazones = new DisplayCorazones()
	const property displayPuntajes = new DisplayPuntajes()
	
	method iniciar() {
		const width = registry.get("grid_width")
		const height = registry.get("grid_height")
		const centro = registry.get("centro")

	}
	
//	method sumarPuntajeFantasma(){
//		//Si el pacman mata a un fantasma se le suma 5 puntos
//		puntaje = puntaje + 5
//		if(puntaje == 10){
//			self.ganar()
//		}
//	}
	method frenarTodo(){
		gameEngine.objetos().forEach { obj =>
			obj.eliminar()
		}
		game.clear()
		sonidos.musica().stop()
	}
	method gameOver(){
		self.frenarTodo()
		const centro = game.center()
		const gameOver = new Imagen(
			x=centro.x(), y=centro.y(), 
			image = "assets/PERDISTE/game over.png",
			height=250,
			width=70
		)
		sonidos.playSound("assets/SONIDOS/bruh.ogg", 1)
		sonidos.playSound("assets/SONIDOS/fail.mp3", 1)
		game.schedule(1000, {
			sonidos.playSound("assets/SONIDOS/risa.mp3", 0.6)
			(1..36).forEach { n =>
				game.schedule(n*100, {
					const rana = new Imagen(
						x=centro.x(), y=centro.y(), 
						image= "assets/PERDISTE/rana-saltando/("+n+").jpg",
						height=675,
						width=540
					)
				})
			}
		})
		game.schedule(5000, {
			const gato = new Imagen(
				x=centro.x(), y=centro.y(), 
				image= "assets/PERDISTE/gatoriendose.jpeg",
				height=705,
				width=705
			)
		})
		
	}
	method ganar(){
		self.frenarTodo()
		const centro = game.center()
		const ganar = new Imagen(
			x=centro.x(), y=centro.y(), 
			image = "assets/ready.png",
			width=10,
			height=10
		)	
	}
}


class Corazon inherits Imagen {
	override method initialize() {
		super()
		self.hacerLleno()
	} 
	method hacerVacio() {
		image = "assets/corazonVacio.png"
	}
	method hacerLleno() {
		image = "assets/corazon.png"
	}
}

class DisplayCorazones {
	const maximoNumeroCorazones = gameEngine.jugador().vidaMaxima()
	var numeroCorazonesActuales = maximoNumeroCorazones
	const listaCorazones = new List()
	
	override method initialize() {
		super()
		const y = registry.get("grid_height")-20
		(1..maximoNumeroCorazones).forEach { n =>
			const x = n*10
			const corazon = new Corazon(x=x, y=y, image="assets/corazon.png")
			listaCorazones.add(corazon)
		}
	}
	method restarCorazones(numeroCorazones) {
		const desde = numeroCorazonesActuales - 1
		const hasta = (numeroCorazonesActuales - numeroCorazones).max(0) // no puede superar 0
		
		(desde..hasta).forEach { n =>
			listaCorazones.get(n).hacerVacio()
		}
	}
	method sumarCorazones(numeroCorazones) {
		const desde = numeroCorazonesActuales - 1
		const hasta = (numeroCorazonesActuales + numeroCorazones).min(maximoNumeroCorazones-1) // no puede superar 0
		
		(desde..hasta).forEach { n =>
			listaCorazones.get(n).hacerLleno()
		}
	}
	method restaurarCompletamente() {
		numeroCorazonesActuales = maximoNumeroCorazones
		listaCorazones.forEach {corazon => 
			corazon.hacerLleno()
		}
	}
	method vaciarCompletamente() {
		numeroCorazonesActuales = 0
		listaCorazones.forEach {corazon => 
			corazon.hacerVacio()
		}
	}
}

class DisplayPuntajes {
	var puntajeActual = 0
	
	override method initialize() {
		super()
		const width = registry.get("grid_width")
		const height = registry.get("grid_height")
		const testo = new Texto(
	  		text="Puntaje: "+puntajeActual,//+jugador.puntaje(),//Agregar aca eo puntaje 
	  		x=width-20,
	  		y=height-20,
	  		textColor="#FFFFFF"
	  	)
	}
}
