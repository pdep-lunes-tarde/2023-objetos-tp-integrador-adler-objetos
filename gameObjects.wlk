import wollok.game.*

import gameEngine.*
import vectores.*
import colisiones.*
import ui.*
import mapa.*




class GameObject {
	const property x0 = registry.get("centro").x() - self.width()/2
	const property y0 = registry.get("centro").y() - self.height()/2
	var property x = x0 	
	var property y = y0
	
	var property hitbox = null 

	
	
	
	var property position = new Vector(x=x0, y=y0) 				
	
	method height() = 40/registry.get("casillas_pixeles")		
	method width() = 40/registry.get("casillas_pixeles")		
	method centro() = self.position() + vector.at(self.width()/2, self.height()/2)
	method image() = "assets/null.png"
	
	override method initialize() {
		super()
		self.mostrar()				
		gameEngine.objetos().add(self)
		hitbox = new Hitbox(objetoAsociado=self)
	}
	
	method mostrar() {
		gameEngine.addVisual(self) 	
	}
	method ocultar() {
		gameEngine.removeVisual(self)
	}
	
	method eliminar() {
		gameEngine.objetos().remove(self)						
		self.ocultar()											
	}
	
	method resolverColisionCon(objeto, vectorCorreccion) {
		game.say(self, "Choque con "+objeto)


		x += vectorCorreccion.x()
		y += vectorCorreccion.y()	


	}
	method resolverColisionCon(objeto) {
		console.println(self.toString()+": Colision con "+objeto)
	}
}


class UpdatableObject inherits GameObject {
	override method initialize() {
		super()
		updater.add(self) 	
	}
	override method eliminar() {
		updater.remove(self)									
		super()
	}
	method update(dt) 
}


class Sangre inherits GameObject {
	override method image() = "assets/PACMAN/sangre3.png" 
	
	override method initialize() {
		super()
		gameEngine.schedule(3000, {self.eliminar()}) 	
	}
}


class VerletObject inherits UpdatableObject {	
	/* Basado en: https:
	 * 			  https:
	 * */  

	const vel_x0 = 0
	const vel_y0 = 0
	 
	var property old_x = x0 - vel_x0 		
	var property old_y = y0 - vel_y0

	var property acc_x = 0 	 				
	var property acc_y = 0
	
	const hayFriccion = true
	
	const g = 0.98
	
	method reiniciar() {
		x = x0 					
		y = y0
		old_x = x0  	
		old_y = y0 
		acc_x = 0 	 				
		acc_y = 0
	}
	
	method tp(_x, _y) {  					
		const vel_x = x - old_x
		const vel_y = y - old_y
		
		x = _x
		y = _x
		old_x = x - vel_x
		old_y = y - vel_y
	}
	
	method accelerate(_acc_x, _acc_y) {
		acc_x += _acc_x
		acc_y += _acc_y
	}
	method accelerate(_vector) {
		acc_x += _vector.x()
		acc_y += _vector.y()
	}
	
	method rapidez() {
		const vel_x = x - old_x
		const vel_y = y - old_y
		return (vel_x*vel_x+vel_y*vel_y).squareRoot()
	}
	
	method updatePosition(dt) {
		
		
		
		
		const vel_x = x - old_x  
		const vel_y = y - old_y
		
		
		old_x = x
		old_y = y
			
		
		if (hayFriccion) {
			x += vel_x * 0.95 + acc_x *dt*dt 
			y += vel_y * 0.95 + acc_y *dt*dt
		} 
		else {
			x += vel_x + acc_x *dt*dt 
			y += vel_y + acc_y *dt*dt
		}
		
		
		acc_x = 0 
		acc_y = 0 
		
		
		position.xy(x, y)
	}
	
	method applyGravity() {
		self.accelerate(0,-g)
	}
	
	method applyCircleConstraint(coord_centro, radio) { 
		const radioDelCirculo = mapa.radioDelCirculo()
		const ejeDeChoque = coord_centro - (vector.at(x, y) + vector.at(radioDelCirculo,radioDelCirculo))
		const dist = ejeDeChoque.magnitud()
		

		
		if (dist > radio) {  
			const diff = dist - radio
			const moverHacia = ejeDeChoque.versor() * diff
		
			/* A GRANDES VELOCIDADES, SE BUGGEA, SOLUCIONES:
			 * - Limitar las velocidades
			 * - Hacer substeps.
			 * - Implementar Continious collision detection.
			 * - Hacer que rebote, reduce las ocurrencias de bug, aunque a veces sigue pasando. 
			 * */
			
			x += moverHacia.x()  
			y += moverHacia.y()  




		}
	}
	method applyWallConstraint() {
		const piso = 0
		const techo = registry.get("grid_height") - self.height() 
		const derecha = registry.get("grid_width") - self.width() 
		const izquierda = 0
		
		const coef_perdida_energia = 0.05
		
		const vel_x = (x - old_x) * (1-coef_perdida_energia) 
		const vel_y = (y - old_y) * (1-coef_perdida_energia)
		
		if (y < piso) {	 								
			y = piso
			old_y = y + vel_y				
		}
		if (x < izquierda) { 
			x = izquierda
			old_x = x + vel_x
		}
		if (y > techo) { 								
			y = techo
			old_y = y + vel_y
		}									
		if (x > derecha) {					
			x = derecha
			old_x = x + vel_x
		}
		
	}       
	
	method applyCirclePathConstraint(coord_centro, radio) {
		const radioDelCirculo = mapa.radioDelCirculo()
		const ejeDeChoque = coord_centro - (vector.at(x, y) + vector.at(radioDelCirculo,radioDelCirculo))
		const dist = ejeDeChoque.magnitud()
		
		if (dist != radio) {  
			const diff = dist - radio
			const moverHacia = ejeDeChoque.versor() * diff	
			x += moverHacia.x()
			y += moverHacia.y()
		}
	}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
	
	override method update(dt) {


		self.updatePosition(dt)
	}
}

class ObjetoConVida inherits VerletObject {
	var property vida = self.vidaMaxima()
	method vidaMaxima()
	
	override method initialize() {
		super()
		hitbox.inscribirEnCirculo(4.5)
	}
	
	method morir() {
		console.println("Rip, "+self+" :(")
		self.eliminar()
	}
	method restarVida(_vida) {
		vida = (vida - _vida).max(0)
		const s = new Sangre(x0=x, y0=y)
		if (vida <= 0) {
			self.morir()
		}
	}
}
