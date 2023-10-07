import wollok.game.*

import gameObjects.*
import vectores.*
import global.*


// x_relativo, y_relativo, objetoAsociado, traslacionRelativa (opcional)
class PuntoDeColision {
	const traslacionRelativa = vector.at(0,0) 
	const property trasRel_x = traslacionRelativa.x()
	const property trasRel_y = traslacionRelativa.y()
	var property x_relativo
	var property y_relativo
	
	const property position = vector.at(x_relativo+trasRel_x,y_relativo+trasRel_y)
	
	var property image = "assets/pixel.png"
	method image(_image) {
		image = _image
	}
	
	method pivote_x(_x) {
		position.x(_x + x_relativo + trasRel_x)
	}
	method pivote_y(_y) {
		position.y(_y + y_relativo + trasRel_y)
	}
}
//
//object colisiones {
//	const property listaFrames = new List()
//	var mostrandoColisiones = false
//	
//	method toggleColisiones() {
//		if (mostrandoColisiones) {
//			listaFrames.forEach{ frame => frame.perimetro().forEach{ ptoColision =>
//				ptoColision.image("assets/pixel.png")
//			}}
//			mostrandoColisiones = false
//		} 
//		else {
//			listaFrames.forEach{ frame => frame.perimetro().forEach{ ptoColision =>
//				ptoColision.image("")
//			}}
//			mostrandoColisiones = true
//		}
//	}
//}

// cosnt frame = new FrameDeColision(objetoAsociado=new GameObject())
// frame.agregarPerimetro(new Rectangulo(altura=10, ancho=10),)
class FrameDeColision { // debe seguir la posicion del gameObject asignado
	const property perimetro = new List() // lista que contiene a los PuntoDeColision
	const property objetoAsociado // hay que pasarle un gameObject al crear una instancia de la clase
	
	method initialize() {
		objetoAsociado.asignarFrame(self)	// automaticamente se asigna al GameObject, después podemos usar "frameDeColision().perimetro()"
	}
	
	method agregarPerimetro(forma, traslacionRelativa) {
		forma.generarPerimetro(traslacionRelativa)
		perimetro.addAll(forma.perimetroGenerado())
	}
}


// COLISIONES DEBEN PROCESARSE EN TORNO AL JUGADOR


class Forma {
	const property perimetroGenerado = new List()
	method generarPerimetro(traslacionRelativa)
	
	method crearPtoEn(ptoRelativo, traslacionRelativa) {
		const ptoColision = new PuntoDeColision(x_relativo=ptoRelativo.x(), y_relativo=ptoRelativo.y(), traslacionRelativa=traslacionRelativa)
		perimetroGenerado.add(ptoColision)
		game.addVisual(ptoColision)
	}
}
class Rectangulo inherits Forma {
	const property altura
	const property ancho
		
	override method generarPerimetro(traslacionRelativa) {
		// Algoritmo para crear el rectangulo: 
		// las coordenadas pasadas por parametro son relativas al pivote del gameObject asociado
		// desde el punto (x0, y0) nos movemos hacia la derecha
		(0 .. ancho-1).forEach { x =>
			self.crearPtoEn(vector.at(x, 0), traslacionRelativa)
		}
		// desde el punto (x0+ancho, y0), nos movemos hacia arriba
		(1 .. altura-1).forEach { y =>
			self.crearPtoEn(vector.at(ancho-1, y), traslacionRelativa)
		}
		// desde el punto (x0+ancho, y0+altura), nos movemos hacia la izquierda
		(ancho-2 .. 0).forEach { x =>
			self.crearPtoEn(vector.at(x, altura-1), traslacionRelativa)
		}
		// desde el punto (x0, y0+altura), nos movemos hacia abajo
		(altura-2 .. 1).forEach { y =>
			self.crearPtoEn(vector.at(0, y), traslacionRelativa)
		}
		// Fin algoritmo, tenemos guardado en "perimetro" un cuadrado que superpone al gameObject dado
	}
}
