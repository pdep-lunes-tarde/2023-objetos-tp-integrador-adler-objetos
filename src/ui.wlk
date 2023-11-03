import global.*
import wollok.game.*
import proyectiles.*

object game_ui {
	var puntaje = 0
	var vidas = 10
	
	//method puntaje() = puntaje
	
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
	  	game.addVisual (new Texto(
	  		text="Vidas:"+vidas,//+jugador.puntaje(),//Agregar aca eo puntaje 
	  		x=width-40,
	  		y=height-20,
	  		textColor="#FFFFFF"
	  	))
	}
	
	method sumarPuntajeBolita() {
		//Si el pacman choca con una bolita se le suma un punto
		puntaje++
		if(puntaje == 10){
			self.ganar()
		}
	}
	method sumarPuntajeFantasma(){
		//Si el pacman mata a un fantasma se le suma 5 puntos
		puntaje = puntaje + 5
		if(puntaje == 10){
			self.ganar()
		}
	}
	
	method calcularVidas() {
		//Si el pacman choca con una bola de fuego o con un fantasma se le resta una vida
		//muestra sangre jugador.morir()
		vidas--
		if(vidas == 0){
			self.gameOver()
		}
	}
	method frenarTodo(){
		//matar al jugador jugador.eliminar
		//eliminar a los fantasmas fantasma.eliminar()
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


class Texto {
	const x 
	const y 
	const property text
	const property textColor
	method position() = game.at(x,y)
}

object gameOver {
	var property position = game.center()	

	method image() = "assets/game over.png"
}

object ganador {
	var property position = game.center()	

	method image() = "assets/ready.png"
}