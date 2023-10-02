class Vector {
	const property x = 0
	const property y = 0
	
	override method toString() {
		return "Vector(" + x.toString() + ", " + y.toString() + ")"
	}
	
	method magnitud() {
		return (x.square() + y.square()).squareRoot()
	}
	
	method +(otroVector) {
		return new Vector(x = x+otroVector.x(), y = y+otroVector.y())
	}
	method -(otroVector) {
		return new Vector(x = x-otroVector.x(), y = y-otroVector.y())
	}
//	method *(otroVector) {
//		return new Vector(x = x*otroVector.x(), y = y*otroVector.y())
//	}
	method *(escalar) {
		return new Vector(x = x*escalar, y = y*escalar)
	}
}












