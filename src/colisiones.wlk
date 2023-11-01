import wollok.game.*

import gameObjects.*
import vectores.*
import global.*


// objeto para checkear colisiones
object colisiones {
	const property conjuntoObjetos = new Set() // es conjunto así no se repiten los mismo objetos
	
	method initialize() {
		super()
	}

	method checkCollisionsOf(objetoPrincipal) {
		
		//objetoPrincipal.checkCollisionsWith(conjuntoObjetos)
		
		/* https://www.youtube.com/watch?v=eED4bSkYCB8
		 * - Checkear cada par -> HORRIBLE
		 * - Sweep & Prune -> método de los intervalos -> muuuuuuuuuchisimo mejor q el anterior
		 * - Space partitioning -> Uniform grids / K-D Trees /  
		 */
		
		// sprite del pacman es de 45 pixeles de largo
		// el largo de una celda es de 5 pixeles 
		// sprite del pacman es de 9 celdas de largo
		// el radio del pacman seria de 4.5 celdas
		const p_radio = objetoPrincipal.radio()
		const p_x0 = objetoPrincipal.x()
 		const p_y0 = objetoPrincipal.y()
 		const p_x1 = p_x0 + objetoPrincipal.width()
 		const p_centro = vector.at(p_x0+p_radio, p_y0+p_radio) 
		const obj_radio = p_radio // suponemos q son un poco mas grandes
		
		// Sweep & Prune 

//		game.say(objetoPrincipal, "Chequeando colisiones...")
//		console.println(conjuntoObjetos.toString())

		 conjuntoObjetos.forEach {obj =>
		 	if (obj != objetoPrincipal) {
		 		const obj_x0 = obj.x()
		 		const obj_x1 = obj_x0 + obj.width()
		 	
		 		// si se solapan en el eje x, entonces puede haber colision
		 		const seSolapanEnElEjeX = obj_x0 < p_x1 and p_x0 < obj_x1
		 		if (seSolapanEnElEjeX) {
//		 			// VERSION HITBOX RECTANGULAR
//		 			const obj_y0 = obj.y()
//		 			const obj_y1 = obj_y0 + obj.height()
//		 			const p_y1 = p_y0 + objetoPrincipal.height()
//		 			
//		 			console.println("X")
//		 			
//		 			const seSolapanEnElEjeY = obj_y0 < p_y1 and p_y0 < obj_y1
//		 			if (seSolapanEnElEjeY) { // CONFIRMADO COLISION
//		 				console.println("Y")
//		 			}
		 			
		 			// VERSION HITBOX CIRCULAR
		 			const obj_centro = obj.position()+vector.at(obj_radio, obj_radio)
		 			const eje_colision = obj_centro - p_centro
		 			const dist = eje_colision.magnitud()
		 			if (dist < p_radio+obj_radio) { // CONFIRMADO HAY COLISION
		 				const diff = (p_radio+obj_radio) - dist
		 			 	const moverHacia = eje_colision.versor() * (-diff/2) 
		 			 	
		 				objetoPrincipal.resolverColisionCon(obj, moverHacia)
		 				obj.resolverColisionCon(objetoPrincipal, moverHacia * (-1))	// se mueve a la direccion contraria
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
