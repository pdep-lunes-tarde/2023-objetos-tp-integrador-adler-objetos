class Vector {
	var property x = 0
	var property y = 0
	
	override method toString() {
		return "Vector(" + x.toString() + ", " + y.toString() + ")"
	}
	
	method magnitud() {
		return (x.square() + y.square()).squareRoot()
	}
	
	// como vector inmutable -> es horrible para la performance D:
	method +(otroVector) {
		return new Vector(x = x+otroVector.x(), y = y+otroVector.y())
	}
	method -(otroVector) {
		return new Vector(x = x-otroVector.x(), y = y-otroVector.y())
	}
	method *(escalar) {
		return new Vector(x = x*escalar, y = y*escalar)
	}
	
	// como vector mutable -> impacta menos a la performance del juego, 
	// el juego va más fluido cuando trabajamos con variables x e y separadas.
	// asique utilizamos vectores solo para cambiar el property "position" de los objetos q es lo que le importa a wollok 
	method y(_y) {
		y = _y
	}
	method x(_x) {
		x = _x
	}
	method at(_x, _y) {
		self.x(_x)
		self.y(_y)
	}
	
	method sumarle(otroVector) {
		x += otroVector.x()
		y += otroVector.y()
	}
	method restarle(otroVector) {
		x -= otroVector.x()
		y -= otroVector.y()
	}
	method multiplicarle(escalar) {
		x *= escalar
		y *= escalar
	}
}

const versor_i = new Vector(x=1,y=0)
const versor_j = new Vector(x=0,y=1)











