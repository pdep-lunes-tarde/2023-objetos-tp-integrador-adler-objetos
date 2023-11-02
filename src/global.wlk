import wollok.game.*
import colisiones.*

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
	const update_list = new Set() // lista que almacena updatableObjects
	
	// definimos como updatableObject a aquellos objetos que entienden el mensaje "update".
	method add(updatableObject) {
		update_list.add(updatableObject)
	}
	method remove(updatableObject) {
		update_list.remove(updatableObject)
	}
	
	method update() {
		// envia el mensaje "update" a cada objeto guardado en la lista update_list
		update_list.forEach({updatableObject => updatableObject.update()}) 
		colisiones.checkearColisiones()
	}
	
	method start() {
		const dt = 1 // tiempo (en ms) que pasa entre cada actualizacion

		game.onTick(dt, "actualizar", { self.update() })

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