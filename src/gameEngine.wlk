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
	var property dt_global
	var enCamaraLenta = false
	
	// definimos como updatableObject a aquellos objetos que entienden el mensaje "update".
	method add(updatableObject) {
		update_list.add(updatableObject)
	}
	method remove(updatableObject) {
		update_list.remove(updatableObject)
	}
	
	method update(dt) {
		// envia el mensaje "update" a cada objeto guardado en la lista update_list
		update_list.forEach({updatableObject => updatableObject.update(dt)})
		colisiones.checkearColisiones() 
	}
	
	// dt es el tiempo (en ms) que pasa por cada tick
	// framesPerTick son los numeros de frames por cada tick
	method start(dt) {
		game.onTick(dt, "actualizar", { self.update(dt) })	
		dt_global = dt	
	}
	
	method stop() {
		game.removeTickEvent("actualizar")
	}
	
	method activarCamaraLenta() {
		if (not enCamaraLenta) {
			self.stop()
			const prev_dt = dt_global
			dt_global *= 10
			game.onTick(dt_global, "actualizar", { self.update(prev_dt/2) })
			gameEngine.restartAllOnTickEvents()
			console.println("Camara lenta activada")	
		}
	}
	method desactivarCamaraLenta() {
		if (enCamaraLenta) {
			self.stop()
			dt_global /= 10
			self.start(dt_global)
			console.println("Camara lenta desactivada")
		}
	}
	method toggleCamaraLenta() {
		if (enCamaraLenta) {
			self.desactivarCamaraLenta()
		} else {
			self.activarCamaraLenta()
		}
		enCamaraLenta = not enCamaraLenta
	}
}

object gameEngine {
	const property allOnTicksEvents = new Set()
	
	method schedule(time, block) {
		game.schedule(time*updater.dt_global(), block)
	}
	method onTick(time, name, block) {
		allOnTicksEvents.add([time, name, block])
		game.onTick(time*updater.dt_global(), name, block)
	}
	method restartAllOnTickEvents() {
		allOnTicksEvents.forEach { onTickEvent =>
			const time = onTickEvent.get(0)
			const name = onTickEvent.get(1)
			const block = onTickEvent.get(2)
			self.removeTickEvent(name)
			self.onTick(time, name, block) 
		}
	}
	method removeTickEvent(name) {
		allOnTicksEvents.remove(name)
		game.removeTickEvent(name)
	}
}