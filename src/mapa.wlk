import gameEngine.*
import vectores.*
import gameObjects.*
import wollok.game.*
import menu.*
import pacman.Pacman
import enemigos.*
import proyectiles.*
import consumibles.*
import ui.*

object mapa {	
	var dificultad = 0
	const property radioDelCirculo = 4.5
	
	method seno_hasta90grados(x) {
		const pi = 3.1416
		const a = x * pi/180 // pasamos grados a radianes
		// Aproximacion del Seno con un polinomio de mclaurin de orden 9, es preciso entre -pi y pi.
		return a-((a**(3))/(6))+((a**(5))/(120))-((a**(7))/(5040)+((a**(9))/(362880)))
	}
	
  	method seno(x) { // es preciso entre -pi y pi
  		if (x < 0) { // para los negativos
  			return -self.seno(-x)
  		}
  		var a = x.abs()%360 // filtramos. Después de 360°, ya es todo lo mismo
  		if (a <= 90) {
  			return self.seno_hasta90grados(a)
  		} 
		if (a > 90 and a <= 180) {
  			return -self.seno_hasta90grados(a - 180)
  		}
  		// si es mayor a 180
  		return -self.seno_hasta90grados(a)
  	}
  	method coseno(x) { 
  		const a = 90 - x 
  		return self.seno(a)
  	}
	
	method iniciar() { // acá agregamos los objetos del juego
		const jugador = new Pacman() 

		self.spawnearFantasmas(2)

	  	
    	game.onTick(35000, "crearCafes", {
    		1.times { n =>
            	const randomX = (60..180).anyOne()
            	const randomY = (30..100).anyOne()
            	const cafe = new Coffee(x0 = randomX, y0 = randomY)
        	}	
    	})
    	
    	game.onTick(50000, "crearLavaBuckets", {
    		1.times { n =>
            	const randomX = (60..180).anyOne()
            	const randomY = (30..100).anyOne()
            	const lavaBucket = new LavaBucket(x0 = randomX, y0 = randomY)
        	}	
    	})
    	
    	game.onTick(30000, "crearSlimeBuckets", {
    		1.times { n =>
            	const randomX = (60..180).anyOne()
            	const randomY = (30..100).anyOne()
            	const slimeBucket = new SlimeBucket(x0 = randomX, y0 = randomY)
        	}	
    	})
    	
    	game.onTick(20000, "crearSnowBuckets", {
    		1.times { n =>
            	const randomX = (60..180).anyOne()
            	const randomY = (30..100).anyOne()
            	const snowBucket = new SnowBucket(x0 = randomX, y0 = randomY)
        	}	
    	})
    	
    	game.onTick(10000, "crearCerezas", {
    		1.times { n =>
            	const randomX = (60..180).anyOne()
            	const randomY = (30..100).anyOne()
            	const cerezas = new Cereza(x0 = randomX, y0 = randomY)
        	}	
    	})
    	
//    	const maximofantasmas = 2
//	  	var cantidadfantasmas = 0
//	  	
//    	game.onTick(1000, "crearFantasmnas", {
//				if(cantidadfantasmas < maximofantasmas){
//					1.times { n =>
//						const vel = 1.randomUpTo(5)
//						const fantasma = new Fantasma(x0=game.center().x()-1 + n*3, y0=game.center().y()+65, vel_x0=1, hayFriccion=false)
//							game.onTick(1, "aceleracion radial", {
//								const aceleracionRadial = (registry.get("centro") - fantasma.position()).versor()*0.1
//								fantasma.accelerate(aceleracionRadial)
//							})
//						cantidadfantasmas++
//					}
//				}
//			}		
//		)

//		ui.displayPuntajes().
		
	}
	
	method spawnearFantasmas(cantidad) {
		
//		const ancho = registry.get("grid_width")
//		const alto = registry.get("grid_height")
//		
//		const rand_x = (0..ancho).anyOne()
//		const rand_y = (0..alto).anyOne()

		cantidad.times { n =>
			const rand_angulo = (-360..360).anyOne()
			const x = game.center().x() + radioDelCirculo * self.coseno(rand_angulo) * 20
			const y = game.center().y() + radioDelCirculo * self.seno(rand_angulo) * 20
			
			const vel = 1.randomUpTo(5)
	 		const fantasma = new Fantasma(x0=x, y0=y, hayFriccion=true)
//		 	game.onTick(1, "aceleracion radial", {
//		 		const aceleracionRadial = (registry.get("centro") - fantasma.position()).versor()*0.1
//		 		fantasma.accelerate(aceleracionRadial)
//		 	})
		}
		
	}
	
	method aumentarDificultad() {
		dificultad += 1
		game.schedule(1000, {
			if (gameEngine.enemigos().asList().isEmpty()) { // cuando ya no hay más fantasmas, spawneamos más
				const cantidad = dificultad.squareRoot().roundUp()
				self.spawnearFantasmas(cantidad)
			}
		})
	}
}








