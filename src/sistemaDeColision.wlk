import wollok.game.*

import gameObjects.*
import vectores.*
import global.*




class PuntoDeColision {
	const traslacionRelativa = vector.at(0,0) 
	const property tras_rel_x = traslacionRelativa.x()
	const property tras_rel_y = traslacionRelativa.y()
	var property x_relativo // relativos al objeto asociado
	var property y_relativo
	
	const property position = vector.at(x_relativo + tras_rel_x, y_relativo + tras_rel_y)
	
	var property image = "assets/pixel.png"
	method image(_image) {
		image = _image
	}
	
	method mover_pivote_x(_x) {
		position.x(_x + x_relativo + tras_rel_x)
	}
	method mover_pivote_y(_y) {
		position.y(_y + y_relativo + tras_rel_y)
	}
}

object colision {
	const frameGenerado = new List()
	method crearFrameDeColision(altura, ancho, traslacion_relativa) {
		frameGenerado.clear() // Limpiar antes de usar
		
		// Algoritmo para crear el rectangulo: 
		// las coordenadas pasadas por parametro son relativas al pivote del gameObject asociado
		// desde el punto (x0, y0) nos movemos hacia la derecha
		(0 .. ancho-1).forEach { x =>
			self.crearPtoEn(vector.at(x, 0), traslacion_relativa)
		}
		// desde el punto (x0+ancho, y0), nos movemos hacia arriba
		(1 .. altura-1).forEach { y =>
			self.crearPtoEn(vector.at(ancho-1, y), traslacion_relativa)
		}
		// desde el punto (x0+ancho, y0+altura), nos movemos hacia la izquierda
		(ancho-2 .. 0).forEach { x =>
			self.crearPtoEn(vector.at(x, altura-1), traslacion_relativa)
		}
		// desde el punto (x0, y0+altura), nos movemos hacia abajo
		(altura-2 .. 1).forEach { y =>
			self.crearPtoEn(vector.at(0, y), traslacion_relativa)
		}
		// Fin algoritmo, tenemos guardado en "perimetro" un cuadrado que superpone al gameObject dado
		
		return frameGenerado
	}
	
	method crearPtoEn(punto, traslacion_relativa) {
		const x = punto.x()
		const y = punto.y()
		const tras_rel_x = traslacion_relativa.x()
		const tras_rel_y = traslacion_relativa.y()
		return new PuntoDeColision(x_relativo=x, y_relativo=y, tras_rel_x=tras_rel_x, tras_rel_y=tras_rel_y)
	}
}
