import global.*
import wollok.game.*

object game_ui {
	method iniciar() {
		const width = registry.get("grid_width")
		const height = registry.get("grid_height")
		const centro = registry.get("centro")
		
		//const puntaje = new TextoPuntaje(x0=200, y0= 200)
		const puntaje = new Texto(
	  		text="Puntaje:",//+jugador.puntaje(),//Agregar aca eo puntaje 
	  		x=centro.x(),
	  		y=centro.y(),
	  		textColor="#FFFFFF"
	  	)
	  	var randomNroBolitas = (1..10).anyOne()
	  	var randomX = (1..100).anyOne()
	  	var randomY = (1..100).anyOne()
	  	
//		randomNroBolitas.times { n =>
//  			var bolita = new Bolita(x0 = randomX, y0 = randomY)
//		}
	}
	
}


class Texto {
	const x 
	const y 
	const property text
	const property textColor
	method position() = game.at(x,y)
}