import wollok.game.*
import global.updater
import vectores.*
import global.*


class CollisionPoint inherits DynamicObject {
	// tiene posición asignada y una imagen null.png
	const gameObjectAsociado // asignarle un gameObject al momento de crear una CollisionPoint
	
	override method update() { // movemos el CollisionPoint relativo al gameObject asociado.
		position.x(x + gameObjectAsociado.x())
		position.y(y + gameObjectAsociado.y())
		
	}
	
	
}

class CollisionFrame { // debe seguir la posicion del gameObject asignado
	const property perimetro = new List() // lista que contiene los CollisionPoints
	
	method asociarPerimetro(forma, gameObject) {
		perimetro.addAll(forma.generarPerimetro(gameObject))
	}
	
}

class Forma {
	const perimetro = new List()
	method generarPerimetro(gameObject)
}
class Rectangulo inherits Forma {
	const property altura
	const property ancho
	
	override method generarPerimetro(gameObject) {
//		const pivote = gameObject.position() // pivote está en el punto más izq-bajo de un gameObject
//		const x0 = pivote.x() 
//		const y0 = pivote.y()
		
		// Algoritmo para crear el rectangulo: 
		// las coordenadas pasadas por parametro son relativas al pivote del gameObject asociado
		// desde el punto (x0, y0) nos movemos hacia la derecha
		(0 .. 0+ancho).forEach { x =>
			const ptoColision = new CollisionPoint(x=x, y=0, gameObjectAsociado=gameObject)
			perimetro.add(ptoColision)
			game.addVisual(ptoColision)
		}
		// desde el punto (x0+ancho, y0), nos movemos hacia arriba
		(0 .. 0+altura).forEach { y =>
			const ptoColision = new CollisionPoint(x=0+ancho, y=y, gameObjectAsociado=gameObject)
			perimetro.add(ptoColision)
			game.addVisual(ptoColision)
		}
		// desde el punto (x0+ancho, y0+altura), nos movemos hacia la izquierda
		(0+ancho .. 0).forEach { x =>
			const ptoColision = new CollisionPoint(x=x, y=0+altura, gameObjectAsociado=gameObject)
			perimetro.add(ptoColision)
			game.addVisual(ptoColision)
		}
		// desde el punto (x0, y0+altura), nos movemos hacia abajo
		(0+altura .. 0).forEach { y =>
			const ptoColision = new CollisionPoint(x=0, y=y, gameObjectAsociado=gameObject)
			perimetro.add(ptoColision)
			game.addVisual(ptoColision)
		}
		
		// Fin algoritmo, tenemos guardado en "perimetro" un cuadrado que superpone al gameObject dado
		
	}
}
class Circulo inherits Forma {
	const property radio
	
	override method generarPerimetro(gameObject) {
		
	}
}

const perimetro1 = new PerimetroDeColision(forma = new Rectangulo(altura=10, ancho=10))
const perimetro2 = new PerimetroDeColision(forma = new Circulo(radio=5))  

class GameObject {
	// usamos variable propias x e y,
	// hace los cálculos muchisimo más rápido que los Vectores (ya lo probé, rip performance), ¿¿¿¿con otros tipos de pares ordenados funcionará????
	var property x = 0
	var property y = 0
	// "position" es lo que le importa a wollok game,
	// por ende usamos "position" nomás para efectuar el cambio de posición. Utilizamos un vector mutable que entiende mensajes "x()" e "y()".
	const property position = new Vector(x=x, y=y) // wollok game debe poder leer la posicion, por ende es property
	var image = "assets/null.png"
	
	method image() = image
	method image(_image_path) {
		image = _image_path
	}
}

class DynamicObject inherits GameObject {
	method initialize() {
		updater.add(self) // se agrega al updater al crearse una instancia de la clase
	}
	method update() 
}


class PhysicsObject inherits DynamicObject {
	var vel_x = 10 // magnitud en pixeles por milisegundo
	var vel_y = 0
	var acel_x = 0 // pixeles por milisegundo al cuadrado 
	var acel_y = 0
	
	const masa = 1
	const coef_friccion = 0.05
	
	override method update() {
		// actualizamos las cantidades fisicas
		x += vel_x
		y += vel_y
		vel_x += acel_x
		vel_y += acel_y
		vel_x -= vel_x * coef_friccion // si usamos Masa, entonces debemos cambiar esta implementacion.
		vel_y -= vel_y * coef_friccion
		
		// controlamos los valores antes de efectuar los cambios 
		self.control() 
		
		// efectuamos los cambios
		position.y(y)
		position.x(x)
	}
	
	method control() // método abstracto
}

object pacman inherits PhysicsObject {
	const magnitud_fuerza = 20
	
	const spriteHeight = 96			 	// tamaño en pixeles de la imagen utilizada
	const spriteWidth = 96				// se puede observar la dimensión de la imágen en el .png
	override method image() = "assets/pacman.png" 	
	
	// crean el efecto de que alguien los tira hacia ese sentido indicado
	method arriba() {
		vel_y += magnitud_fuerza * masa							// aplicar fuerza vertical hacia arriba
	}
	method abajo() {
		vel_y -= magnitud_fuerza * masa							// aplicar fuerza vertical hacia abajo
	}
	method derecha() {
		vel_x += magnitud_fuerza * masa							// aplicar fuerza horizontal hacia derecha
	}
	method izquierda() {
		vel_x -= magnitud_fuerza * masa							// aplicar fuerza horizontal hacia izquierda
	}
	
	override method control() {
		// para que no se salga de la ventana
		const piso = 0
		const techo = registry.get("window_height") - spriteHeight // hay q tener en cuenta el tamaño del sprite,
		const derecha = registry.get("window_width") - spriteWidth // ya que el pivot está en la esquina abajo-izquierda del sprite.
		const izquierda = 0
		
		if (y < piso) {	 					// cuando encuentra el piso
			y = piso
			vel_y = -vel_y * 0.6			// hacemos que rebote con una leve perdida de energia 
		}
		if (x < izquierda) { 
			x = izquierda
			vel_x = -vel_x * 0.6
		}
		if (y > techo) { 					// cuando encuentra el techo
			y = techo
			vel_y = -vel_y * 0.6   		
		}									
		if (x > derecha) {					
			x = izquierda
			//vel_x = -vel_x * 0.6    
		}
	}
}




//// deberiamos detectar la colision con el jugador, 
//// pero no entre las distintas instancias de los fantasmas
//class Fantasma {
//	var property position = game.at(0,0) // inicia los fantasmas en el (0,0)
//	
//	// unidad: pixel
//	var x = position.x() 					// usamos variable propias para x e y para poder hacer otros calculos
//	var y = position.y()
//	
//	const spriteHeight = 96 			 	// tamaño en pixeles de la imagen utilizada
//	const spriteWidth = 96 					// se puede observar la dimensión de la imágen en el .png
//	method image() = "assets/pacman.png" 
//	
//	method update() {
//		// acá iría la IA de los fantasmas
//	}
//}


