import wollok.game.*

import gameObjects.*
import vectores.*
import global.*


// x, y, traslacionRelativa (opcional), objectoAsociado
class PuntoDeColision inherits DynamicObject {
	const traslacionRelativa = vector.at(0,0) 
	// tiene posición asignada y una imagen null.png
	const objetoAsociado // asignarle un gameObject al momento de crear un PuntoDeColision
	override method update() {
		position.x(x + objetoAsociado.x() + traslacionRelativa.x()) 	// las variables propias x e y guardan la posición relativa al gameObject asociado.
		position.y(y + objetoAsociado.y() + traslacionRelativa.y())	    // mientras que las variables x e y del "position" son las coors absolutas.
	}
}

// cosnt frame = new FrameDeColision(objetoAsociado=new GameObject())
// frame.agregarPerimetro(new Rectangulo(altura=10, ancho=10),)
class FrameDeColision { // debe seguir la posicion del gameObject asignado
	const property perimetro = new List() // lista que contiene a los PuntoDeColision
	const property objetoAsociado // hay que pasarle un gameObject al crear una instancia de la clase
	
	method initialize() {
		objetoAsociado.asignarFrame(self)	// se asigna solo al GameObject, el cual entiende el mensaje "frameDeColision()"
	}
	
	method agregarPerimetro(forma, traslacionRelativa) {
		forma.generarPerimetro(objetoAsociado, traslacionRelativa)
		perimetro.addAll(forma.perimetroGenerado())
	}
}


// COLISIONES DEBEN PROCESARSE EN TORNO AL JUGADOR


class Forma {
	const property perimetroGenerado = new List()
	method generarPerimetro(gameObject, traslacionRelativa)
	
	method crearPtoEn(ptoRelativo, gameObject, traslacionRelativa) {
		const ptoColision = new PuntoDeColision(x=ptoRelativo.x(), y=ptoRelativo.y(), objetoAsociado=gameObject, traslacionRelativa=traslacionRelativa, image="assets/pixel.png")
		perimetroGenerado.add(ptoColision)
		game.addVisual(ptoColision)
		updater.add(ptoColision) // agregamos cada uno al updater
	}
}
class Rectangulo inherits Forma {
	const property altura
	const property ancho
		
	override method generarPerimetro(gameObject, traslacionRelativa) {
		// Algoritmo para crear el rectangulo: 
		// las coordenadas pasadas por parametro son relativas al pivote del gameObject asociado
		// desde el punto (x0, y0) nos movemos hacia la derecha
		(0 .. 0+ancho).forEach { x =>
			self.crearPtoEn(vector.at(x, 0), gameObject, traslacionRelativa)
		}
		// desde el punto (x0+ancho, y0), nos movemos hacia arriba
		(0 .. 0+altura).forEach { y =>
			self.crearPtoEn(vector.at(0+ancho, y), gameObject, traslacionRelativa)
		}
		// desde el punto (x0+ancho, y0+altura), nos movemos hacia la izquierda
		(0+ancho .. 0).forEach { x =>
			self.crearPtoEn(vector.at(x, 0+altura), gameObject, traslacionRelativa)
		}
		// desde el punto (x0, y0+altura), nos movemos hacia abajo
		(0+altura .. 0).forEach { y =>
			self.crearPtoEn(vector.at(0, y), gameObject, traslacionRelativa
		}
		
		// Fin algoritmo, tenemos guardado en "perimetro" un cuadrado que superpone al gameObject dado
	}
}
class Circulo inherits Forma {
	const property radio
	
	override method generarPerimetro(gameObject)
}
