import wollok.game.*

import gameObjects.*
import vectores.*
import gameEngine.*


class Hitbox { 
	
	const objetoAsociado 
	var height = objetoAsociado.height() 
	var width = objetoAsociado.width()   
	var offset_x = 0
	var offset_y = 0
	
	method obj_pos() = objetoAsociado.position()
	
	
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


object colisiones {
	
	method checkearColisiones() { 
		self.checkCollisionsOfXsWithYs([gameEngine.jugador()], gameEngine.proyectilesEnemigos())
		self.checkCollisionsOfXsWithYs([gameEngine.jugador()], gameEngine.consumibles())
		self.checkCollisionsOfXsWithYs(gameEngine.enemigos(), gameEngine.proyectilesJugador()) 
	}
	
	
	method checkCollisionsOfXsWithYs(objs1, objs2) {	
		/* https:
		 */
		objs1.forEach {obj1 =>
			const obj1_x0 = obj1.hitbox().x0()
	 		const obj1_x1 = obj1.hitbox().x1()
	      
			objs2.forEach {obj2 =>
			 	if (obj2 != obj1) {
			 		const obj2_x0 = obj2.hitbox().x0()
			 		const obj2_x1 = obj2.hitbox().x1()
			 	
			 		
			 		if (obj2_x0 < obj1_x1 and obj1_x0 < obj2_x1) {
			 			const obj2_y0 = obj2.hitbox().y0()
			 			const obj2_y1 = obj2.hitbox().y1()
			 			const obj1_y0 = obj1.hitbox().y0()
			 			const obj1_y1 = obj1.hitbox().y1()
			 			
			 			
			 			if (obj2_y0 < obj1_y1 and obj1_y0 < obj2_y1) { 
			 				obj2.resolverColisionCon(obj1)

			 			}
			 		}
			 	} 
			}
		} 
		
	}	
}

