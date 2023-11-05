import gameEngine.*
import wollok.game.*
import proyectiles.*
import gameObjects.*
import menu.*

object game_ui {
	method iniciar() {
		const width = registry.get("grid_width")
		const height = registry.get("grid_height")
		const centro = registry.get("centro")

//		const displayCorazones = new DisplayCorazones()
		console.println("game_ui")
	}
	
//	method agregarCorazonesVacios(vidas) {
//	  	if(vidas == 2){
//			self.quitar1Vida()
//	  	}
//	  	if(vidas == 1){
//			self.quitar1Vida()
//			self.quitar2Vidas()
//	  	}
//	  	if(vidas == 0){
//			self.quitar1Vida()
//			self.quitar2Vidas()
//	  		game.removeVisual(corazon1)
//	  		game.addVisual (new Corazon(x=10, ))
//	  		self.gameOver()
//	  	}
//	  }
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
		const gameOver = new Imagen(x=centro.x(), y=centro.y(), image = "assets/game over.png")
	}
	method ganar(){
		self.frenarTodo()
		const centro = game.center()
		const ganar = new Imagen(x=centro.x(), y=centro.y() , image = "assets/ready.png")	
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
	const maximoCorazones = gameEngine.jugador().vidaMaxima()
	const corazones = maximoCorazones
	const listaCorazones = new List()
	
	override method initialize() {
		super()
		const y = registry.get("grid_height")-20
		(1..3).forEach { n =>
			const x = n*10
			const corazon = new Corazon(x=x, y=y)
			listaCorazones.add(corazon)
		}
	}
	method restarCorazones(numeroCorazones) {
		const desde = maximoCorazones - 1
		const hasta = (maximoCorazones - numeroCorazones).max(0) // no puede superar 0
		
		(desde..hasta).forEach { n =>
			listaCorazones.get(n).hacerVacio()
		}
	}
	method sumarCorazones(numeroCorazones) {
		
	}
	method restaurarCompletamente() {
		listaCorazones.forEach {corazon => 
			corazon.hacerLleno()
		}
	}
	method vaciarCompletamente() {
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
