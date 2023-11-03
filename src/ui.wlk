import global.*
import wollok.game.*
import proyectiles.*
import gameObjects.*
import menu.*

object game_ui {
	var puntaje = 0
	var vidas = 3
	const corazon1 = new Corazon(x=10, image="assets/corazon.png")
	const corazon2 = new Corazon(x=20, image="assets/corazon.png")
	const corazon3 = new Corazon(x=30, image="assets/corazon.png")
	
	method iniciar() {
		const width = registry.get("grid_width")
		const height = registry.get("grid_height")
		const centro = registry.get("centro")

		game.addVisual (new Texto(
	  		text="Puntaje: "+puntaje,//+jugador.puntaje(),//Agregar aca eo puntaje 
	  		x=width-20,
	  		y=height-20,
	  		textColor="#FFFFFF"
	  	))
	  	game.addVisual(corazon1)
	  	game.addVisual(corazon2)
	  	game.addVisual(corazon3)
	  	self.agregarCorazonesVacios()
	}
	
	method agregarCorazonesVacios() {
	  	if(vidas == 2){
			self.quitar1Vida()
	  	}
	  	else if(vidas == 1){
			self.quitar1Vida()
			self.quitar2Vidas()
	  	}
	  	else if(vidas == 0){
			self.quitar1Vida()
			self.quitar2Vidas()
	  		game.removeVisual(corazon1)
	  		game.addVisual (new Corazon(x=10, image="assets/corazonVacio.png"))
	  		self.gameOver()
	  	}
	  }
	 method quitar1Vida(){
	 	game.removeVisual(corazon3)
	  	game.addVisual (new Corazon(x=30, image="assets/corazonVacio.png"))
	 }
	 method quitar2Vidas(){
	  	game.removeVisual(corazon2)
	  	game.addVisual (new Corazon(x=20, image="assets/corazonVacio.png"))
	 }
	 
	method sumarPuntajeFantasma(){
		//Si el pacman mata a un fantasma se le suma 5 puntos
		puntaje = puntaje + 5
		if(puntaje == 10){
			self.ganar()
		}
	}
	
	method restarVidas() {
		//Si el pacman choca con una bola de fuego o con un fantasma se le resta una vida
		//muestra sangre jugador.morir()
		vidas--
	}
	method frenarTodo(){
		gameObjects.objetos().forEach { obj =>
			obj.eliminar()
		}
		game.clear()
		menu.musica().stop()
	}
	method gameOver(){
		self.frenarTodo()
		game.addVisual(gameOver)
	}
	method ganar(){
		self.frenarTodo()
		game.addVisual(ganador)		
	}
	
}

class Corazon {
	const x 
	const y = registry.get("grid_height")-20
	var property image
	method position() = game.at(x,y)
}

class Texto {
	const x 
	const y 
	const property text
	const property textColor
	method position() = game.at(x,y)
}

object gameOver {
	var property position = game.at(90,90)	

	method image() = "assets/game over.png"
}

object ganador {
	var property position = game.center()	

	method image() = "assets/ready.png"
}