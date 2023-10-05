import gameObjects.*
import vectores.*

// valores iniciales: x, y, traslacionRelativa (opcional), objectoAsociado
class PuntoDeColision inherits DynamicObject {
	const traslacionRelativa = new Vector(x=0,y=0) 
	// tiene posición asignada y una imagen null.png
	const objectoAsociado // asignarle un gameObject al momento de crear un PuntoDeColision
	override method update() { 
		position.x(x + objectoAsociado.x() + traslacionRelativa.x()) 	// las variables propias x e y guardan la posición relativa al gameObject asociado.
		position.y(y + objectoAsociado.y() + traslacionRelativa.y())	// mientras que las variables x e y del "position" son las coors absolutas.
	}
}

class FrameDeColision { // debe seguir la posicion del gameObject asignado
	const property perimetro = new List() // lista que contiene a los PuntoDeColision
	
	method agregarPerimetro(gameObject, forma, traslacionRelativa) {
		perimetro.addAll(forma.generarPerimetro(gameObject, traslacionRelativa))
	}
	
}

const hitbox = new FrameColision()
const forma = new Rectangulo(altura=10, ancho=10)
//hitbox.agregarPerimetro(new GameObject(), forma, new Vector(x=10,x=10))

class Forma {
	const perimetro = new List()
	method generarPerimetro(gameObject, traslacionRelativa)
	
	method crearPtoEn(x, y, gameObject, traslacionRelativa) {
		const ptoColision = new PuntoDeColision(x=x, y=y, objectoAsociado=gameObject, traslacionRelativa=traslacionRelativa)
		perimetro.add(ptoColision)
		game.addVisual(ptoColision)
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
			self.crearPtoEn(x, 0, gameObject, traslacionRelativa)
		}
		// desde el punto (x0+ancho, y0), nos movemos hacia arriba
		(0 .. 0+altura).forEach { y =>
			self.crearPtoEn(x=0+ancho, y=y, gameObject, traslacionRelativa)
		}
		// desde el punto (x0+ancho, y0+altura), nos movemos hacia la izquierda
		(0+ancho .. 0).forEach { x =>
			self.crearPtoEn(x=x, y=0+altura, gameObject, traslacionRelativa)
		}
		// desde el punto (x0, y0+altura), nos movemos hacia abajo
		(0+altura .. 0).forEach { y =>
			self.crearPtoEn(x=0, y=y, gameObject, traslacionRelativa
		}
		
		// Fin algoritmo, tenemos guardado en "perimetro" un cuadrado que superpone al gameObject dado
	}
}
class Circulo inherits Forma {
	const property radio
	
	override method generarPerimetro(gameObject) {
		const hitbox = new FrameDeColision()
		hitbox.agregarPerimetro()
	}
}

//const perimetro1 = new PerimetroDeColision(forma = new Rectangulo(altura=10, ancho=10))
//const perimetro2 = new PerimetroDeColision(forma = new Circulo(radio=5))  
