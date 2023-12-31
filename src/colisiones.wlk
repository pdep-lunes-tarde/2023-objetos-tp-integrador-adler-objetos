import wollok.game.*

import gameObjects.*
import vectores.*
import gameEngine.*


class Hitbox { // representa un rectangulo 
	// valores iniciales que podemos inicializar 
	const objetoAsociado // este es obligatorio
	var height = objetoAsociado.height() // Por default, la altura y ancho de la hitbox 
	var width = objetoAsociado.width()   // es la misma que la del objeto asociado.
	var offset_x = 0
	var offset_y = 0
	
	override method initialize() {
		super()
		
	}
	
	method obj_pos() = objetoAsociado.position()
	
	// los 4 puntos de la hitbox
	method x0() = self.obj_pos().x() + offset_x
	method x1() = self.x0() + width + offset_x
	method y0() = self.obj_pos().y() + offset_y
	method y1() = self.y0() + height + offset_y
	
	method centrar() {
		const diff_x = objetoAsociado.width() - width 
		const diff_y = objetoAsociado.height() - height
		offset_x = diff_x/2
		offset_y = diff_y/2
	}
	method inscribirEnCirculo(radio) {
		 const length = 1.414 * radio
		 height = length
		 width = length
		 self.centrar()
	}
	method height(_height) {
		height = _height
	}
	method width(_width) {
		width = _width
	}
	
}

// objeto para checkear colisiones
object colisiones {
	method initialize() {
		super()
	}
	
	method checkearColisiones() { // poner acá las colisiones que queremos checkear 
		self.checkCollisionsOfXsWithYs([gameEngine.jugador()], gameEngine.proyectilesEnemigos())
		self.checkCollisionsOfXsWithYs([gameEngine.jugador()], gameEngine.consumibles())
		self.checkCollisionsOfXsWithYs(gameEngine.enemigos(), gameEngine.proyectilesJugador()) 
	}
	
	// objs2 son los que hacen efecto sobre los objs1. 
	method checkCollisionsOfXsWithYs(objs1, objs2) {	
		/* https://www.youtube.com/watch?v=eED4bSkYCB8
		 */
		objs1.forEach {obj1 =>
			const obj1_x0 = obj1.hitbox().x0()
	 		const obj1_x1 = obj1.hitbox().x1()
	      
			objs2.forEach {obj2 =>
			 	if (obj2 != obj1) {
			 		const obj2_x0 = obj2.hitbox().x0()
			 		const obj2_x1 = obj2.hitbox().x1()
			 	
			 		// se solapan en el eje x ?
			 		if (obj2_x0 < obj1_x1 and obj1_x0 < obj2_x1) {
			 			const obj2_y0 = obj2.hitbox().y0()
			 			const obj2_y1 = obj2.hitbox().y1()
			 			const obj1_y0 = obj1.hitbox().y0()
			 			const obj1_y1 = obj1.hitbox().y1()
			 			
			 			// se solapan en el eje y ?
			 			if (obj2_y0 < obj1_y1 and obj1_y0 < obj2_y1) { // CONFIRMADO COLISION
			 				obj2.resolverColisionCon(obj1)
//			 				obj1.resolverColisionCon(obj2)
			 			}
			 		}
			 	} 
			}
		} 
		
	}	
}











//// x_relativo, y_relativo, objetoAsociado, traslacionRelativa (opcional)
//class PuntoDeColision {
//	const traslacionRelativa = vector.at(0,0) 
//	const property trasRel_x = traslacionRelativa.x()
//	const property trasRel_y = traslacionRelativa.y()
//	var property x_relativo
//	var property y_relativo
//	
//	const property position = vector.at(x_relativo+trasRel_x,y_relativo+trasRel_y)
//	
//	var property image = "assets/pixel.png"
//	method image(_image) {
//		image = _image
//	}
//	
//	method pivote_x(_x) {
//		position.x(_x + x_relativo + trasRel_x)
//	}
//	method pivote_y(_y) {
//		position.y(_y + y_relativo + trasRel_y)
//	}
//}
////
////object colisiones {
////	const property listaFrames = new List()
////	var mostrandoColisiones = false
////	
////	method toggleColisiones() {
////		if (mostrandoColisiones) {
////			listaFrames.forEach{ frame => frame.perimetro().forEach{ ptoColision =>
////				ptoColision.image("assets/pixel.png")
////			}}
////			mostrandoColisiones = false
////		} 
////		else {
////			listaFrames.forEach{ frame => frame.perimetro().forEach{ ptoColision =>
////				ptoColision.image("")
////			}}
////			mostrandoColisiones = true
////		}
////	}
////}
//
//// cosnt frame = new FrameDeColision(objetoAsociado=new GameObject())
//// frame.agregarPerimetro(new Rectangulo(altura=10, ancho=10),)
//class FrameDeColision { // debe seguir la posicion del gameObject asignado
//	const property perimetro = new List() // lista que contiene a los PuntoDeColision
//	const property objetoAsociado // hay que pasarle un gameObject al crear una instancia de la clase
//	
//	method initialize() {
//		objetoAsociado.asignarFrame(self)	// automaticamente se asigna al GameObject, después podemos usar "frameDeColision().perimetro()"
//	}
//	
//	method agregarPerimetro(forma, traslacionRelativa) {
//		forma.generarPerimetro(traslacionRelativa)
//		perimetro.addAll(forma.perimetroGenerado())
//		perimetro.forEach { puntoDeColision =>
//			game.onCollideDo(puntoDeColision, { conQueColisione => console.println(puntoDeColision.toString() + " choco con " + conQueColisione.toString() + " -- " + " en el objeto " + objetoAsociado.toString()) })
//		}
//	}
//}
//
//
//// COLISIONES DEBEN PROCESARSE EN TORNO AL JUGADOR
//
//
//class Forma {
//	const property perimetroGenerado = new List()
//	method generarPerimetro(traslacionRelativa)
//	
//	method crearPtoEn(ptoRelativo, traslacionRelativa) {
//		const ptoColision = new PuntoDeColision(x_relativo=ptoRelativo.x(), y_relativo=ptoRelativo.y(), traslacionRelativa=traslacionRelativa)
//		perimetroGenerado.add(ptoColision)
//		game.addVisual(ptoColision)
//	}
//}
//class Rectangulo inherits Forma {
//	const property altura
//	const property ancho
//		
//	override method generarPerimetro(traslacionRelativa) {
//		// Algoritmo para crear el rectangulo: 
//		// las coordenadas pasadas por parametro son relativas al pivote del gameObject asociado
//		// desde el punto (x0, y0) nos movemos hacia la derecha
//		(0 .. ancho-1).forEach { x =>
//			self.crearPtoEn(vector.at(x, 0), traslacionRelativa)
//		}
//		// desde el punto (x0+ancho, y0), nos movemos hacia arriba
//		(1 .. altura-1).forEach { y =>
//			self.crearPtoEn(vector.at(ancho-1, y), traslacionRelativa)
//		}
//		// desde el punto (x0+ancho, y0+altura), nos movemos hacia la izquierda
//		(ancho-2 .. 0).forEach { x =>
//			self.crearPtoEn(vector.at(x, altura-1), traslacionRelativa)
//		}
//		// desde el punto (x0, y0+altura), nos movemos hacia abajo
//		(altura-2 .. 1).forEach { y =>
//			self.crearPtoEn(vector.at(0, y), traslacionRelativa)
//		}
//		// Fin algoritmo, tenemos guardado en "perimetro" un cuadrado que superpone al gameObject dado
//	}
//}
