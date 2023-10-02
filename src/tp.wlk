import wollok.game.*
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
	  	registry.put("window_width", width)
	  	registry.put("window_height", height)
	  	
	  	// agregar visuales
	  	game.addVisualCharacter(pacman_en_esteroides)
	  	game.addVisual(new Obstaculo())
	  	
		
		// updater
		updater.add(pacman_en_esteroides)
		updater.start()
		
		// teclado
		keyboard.w().onPressDo { 
			pacman_en_esteroides.arriba()
		}
		keyboard.a().onPressDo { 
			pacman_en_esteroides.izquierda()
		}
		keyboard.s().onPressDo { 
			pacman_en_esteroides.abajo()
		}
		keyboard.d().onPressDo { 
			pacman_en_esteroides.derecha()
		}
		
		//game.whenCollideDo(pacman_en_esteroides, {x => x.say("asdasd")})
	}
	
}

// implementar Vectores
// colisiones circulos, cuadrados
// 



object pacman_en_esteroides {
	var property position = game.center()
	
	// unidad: pixel
	var x = position.x() 					// usamos variable propias para x e y para poder hacer otros calculos
	var y = position.y()
	var property vel_x = 10 				// le damos velocidad-x inicial
	var property vel_y = 0
	const magnitud_fuerza = 15
	// suponemos que su masa es igual a 1.
	
	
	const spriteHeight = 96 			 	// tamaño en pixeles de la imagen utilizada
	const spriteWidth = 96 					// se puede observar la dimensión de la imágen en el .png
	method image() = "assets/pacman.png" 	// TODO: existe función para obtener las dimensioens de la imagen utilizada ??
	
	
	// crean el efecto de que alguien los tira hacia ese sentido indicado
	method arriba() {
		//position = position.up(pixeles)
		vel_y += magnitud_fuerza * 1						// aplicar fuerza vertical hacia arriba
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
		// para que no se salga de la ventana
		const piso = 0
		const techo = registry.get("window_height") - spriteHeight // hay q tener en cuenta el tamaño del sprite,
		const derecha = registry.get("window_width") - spriteWidth // ya que el pivot está en la esquina abajo-izquierda del sprite.
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
		
		
		x += vel_x
		y += vel_y
		vel_x -= vel_x * 0.05 // aplicamos friccion en eje x
		vel_y -= vel_y * 0.05 // aplicamos friccion en eje y
		
		// aplica los cambios de posición
		position = game.at(x,y)
	}
}




// deberiamos detectar la colision con el jugador, 
// pero no entre las distintas instancias de los fantasmas
class Fantasma {
	var property position = game.at(0,0) // inicia los fantasmas en el (0,0)
	
	// unidad: pixel
	var x = position.x() 					// usamos variable propias para x e y para poder hacer otros calculos
	var y = position.y()
	
	const spriteHeight = 96 			 	// tamaño en pixeles de la imagen utilizada
	const spriteWidth = 96 					// se puede observar la dimensión de la imágen en el .png
	method image() = "assets/pacman.png" 
	
	method update() {
		// acá iría la IA de los fantasmas
	}
}


