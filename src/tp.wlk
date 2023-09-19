import wollok.game.*
import vectores.Vector
import global.registry
import global.updater


object tpIntegrador {
	method jugar() {
		game.start()
	}
	method iniciar(width, height, title) {
		// iniciar ventana
		game.width(width) // nro de celdas
	  	game.height(height) 
	  	game.cellSize(1) // fijado a 1 píxel
	  	game.title(title)
	  	
	  	// guardo valores globales
	  	registry.put("width", width)
	  	registry.put("height", height)
	  	registry.put("pixelesPorMetro", 100)
	  	
	  	// agregar visuales
	  	game.addVisualCharacter(pacman_en_esteroides)
		
		// updater
		updater.add(pacman_en_esteroides)
		updater.start()
		
		// teclado
		keyboard.w().onPressDo { 
			pacman_con_gravedad.arriba()
		}
		keyboard.a().onPressDo { 
			pacman_con_gravedad.izquierda()
		}
		keyboard.s().onPressDo { 
			pacman_con_gravedad.abajo()
		}
		keyboard.d().onPressDo { 
			pacman_con_gravedad.derecha()
		}
	}
	
}


class Pacman {
	var vidas = 3 // corazones
	var property position = game.center()
	
	const pixelesDeMovimiento = registry.get("cellSize") / 100
	
	method image() = "assets/pacman.png"

	
	method arriba() {
		position = position.up(pixelesDeMovimiento)
	}
	method abajo() {
		position = position.down(pixelesDeMovimiento)
	}
	method derecha() {
		position = position.right(pixelesDeMovimiento)
	}
	method izquierda() {
		position = position.left(pixelesDeMovimiento)
	}
	
	method morir() {
		vidas -= 1 						// pierde una vida
		// animación de muerte
		// reaparecer en el spawnpoint
	}
}

object pacman_en_esteroides {
	var property position = game.center()
	
	// unidad: pixel
	var x = position.x() 				// usamos variable propias para x e y para poder hacer otros calculos
	var y = position.y()
	var property vel_x = 10 			// le damos velocidad-x inicial
	var property vel_y = 0
	const magnitud_fuerza = 15
	
	// tamaño en pixeles de la imagen utilizada
	const spriteHeight = 96 // se puede observar la dimensión de la imágen en el .png
	const spriteWidth = 96
	method image() = "assets/pacman.png" // TODO: existe función para obtener las dimensioens de la imagen utilizada ??
	
	
	// crean el efecto de que alguien los tira hacia ese sentido indicado
	method arriba() {
		//position = position.up(pixeles)
		vel_y += magnitud_fuerza 							// aplicar fuerza vertical hacia arriba
	}
	method abajo() {
		//position = position.down(pixeles)
		vel_y -= magnitud_fuerza							// aplicar fuerza vertical hacia abajo
	}
	method derecha() {
		//position = position.right(pixeles)
		vel_x += magnitud_fuerza							// aplicar fuerza horizontal hacia derecha
	}
	method izquierda() {
		//position = position.left(pixeles)
		vel_x -= magnitud_fuerza							// aplicar fuerza horizontal hacia izquierda
	}
	
	// todos los updates deben devolver bloques para poder pasarlos como parametros en el actualizador global
	method update() {
		vel_x -= vel_x * 0.05 // aplicamos friccion en eje x
		vel_y -= vel_y * 0.05 // aplicamos friccion en eje y
		x += vel_x
		y += vel_y
		
		
		// para que no se salga de la ventana
		
		const piso = 0
		const techo = registry.get("height") - spriteHeight // hay q tener en cuenta el tamaño del sprite,
		const derecha = registry.get("width") - spriteWidth // ya que el pivot está en la esquina abajo-izquierda del sprite
		const izquierda = 0
		
		if (y < piso) {	 					// cuando encuentra el piso
			y = piso
			//vel_y = -vel_y * 0.6  		// hace que rebote, medio bugatti
		} 
		if (x < izquierda) { 
			x = izquierda
		}
		if (y > techo) { 					// cuando encuentra el techo
			y = techo   		
		}									
		if (x > derecha) {					
			x = derecha    
		}							
		
		// aplica los cambios de posición
		position = game.at(x,y)
	}
}

