import wollok.game.*

// para guardar datos importantes y que sean accesibles por cualqueir objeto del programa
object registry {
	const registry = new Dictionary()
	
	method put(keyName, value) { // guarda el valor dado bajo la llave dada
		registry.put(keyName, value)
	}
	method get(keyName) = registry.get(keyName) // devuelve el valor asociada a la llave dada
} 

// un actualizador global
// se agregan objetos actualizables (osea que entienden el mensaje "update") 
// y se actualizan en cada tick de programa 
object updater {
	const update_list = new List() // lista que almacena updatableObjects
	
	// definimos como updatableObject a aquellos objetos que entienden el mensaje "update".
	method add(updatableObject) {
		update_list.add(updatableObject)
	}
	method remove(updatableObject) {
		update_list.remove(updatableObject)
	}
	
	method updateAll(dt) {
		// envia el mensaje "update" a cada objeto guardado en la lista update_list
		update_list.forEach({updatableObject => updatableObject.update(dt)}) 
	}
	
	method start() {
		const dt = 1 // tiempo (en ms) que pasa entre cada actualizacion
		const substeps = 1 // si es igual a 2, ent por cada tick de juego, actualiza dos veces, para mejores fisicas. se re traba asiq sadge :(
		const sub_dt = dt / substeps
		
		
		game.onTick(dt, "actualizar", {
			(1 .. substeps).forEach{ a => 
				self.updateAll(sub_dt)
			}
		})

//		var i=0
//		update_list.forEach({updatableObject => 
//			// agregar un reloj propio para cada objeto. parece que es mejor para la performance del juego
//			game.onTick(dt, "actualizar"+i, {
//				(1 .. substeps).forEach{ a => 
//					updatableObject.update(sub_dt)
//				}
//			})
//			i++
//		}) 
		
	}
	
	method stop() {
		game.removeTickEvent("actualizar")
	}
}


object timer { 
	const timeUnit = ms // ms | s | h 
	var elapsed_time_ms = 0 
	
	method start() {
		game.onTick(1, "elapse", { elapsed_time_ms++ }) // contar cada milisegundo que pasa desde que se inicia el contador
	}
	
	method stop() {
		game.removeTickEvent("elapse")
		return elapsed_time_ms
	}
}

object ms { // milisegundos
	
}

object s { // segundos 
	
}

object h { // hora
	
}



