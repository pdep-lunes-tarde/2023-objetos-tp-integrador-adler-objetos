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
		const a = x * pi/180 
		
		return a-((a**(3))/(6))+((a**(5))/(120))-((a**(7))/(5040)+((a**(9))/(362880)))
	}
	
  	method seno(x) { 
  		if (x < 0) { 
  			return -self.seno(-x)
  		}
  		var a = x.abs()%360 
  		if (a <= 90) {
  			return self.seno_hasta90grados(a)
  		} 
		if (a > 90 and a <= 180) {
  			return -self.seno_hasta90grados(a - 180)
  		}
  		
  		return -self.seno_hasta90grados(a)
  	}
  	method coseno(x) { 
  		const a = 90 - x 
  		return self.seno(a)
  	}
	
	method iniciar() { 
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
		
	}
	
	method spawnearFantasmas(cantidad) {
		
		cantidad.times { n =>
			const rand_angulo = (-360..360).anyOne()
			const x = game.center().x() + radioDelCirculo * self.coseno(rand_angulo) * 20
			const y = game.center().y() + radioDelCirculo * self.seno(rand_angulo) * 20
			
			const vel = 1.randomUpTo(5)
	 		const fantasma = new Fantasma(x0=x, y0=y, hayFriccion=true)
		}
		
	}
	
	method aumentarDificultad() {
		dificultad += 1
		game.schedule(1000, { x =>
			if (gameEngine.enemigos().asList().isEmpty()) { 
				const cantidad = dificultad.squareRoot().roundUp()
				self.spawnearFantasmas(cantidad)
			}
		})
	}
}