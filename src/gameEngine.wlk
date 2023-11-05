import wollok.game.*
import colisiones.*
import vectores.*

class Visual {
	var property x = game.center().x()
	var property y = game.center().y()
	method position() = game.at(x,y) // es lo que wollok game lee para posicionarlo 
	 
	override method initialize() {
		super()
		self.mostrar()
	}
	method mostrar() {
		gameEngine.addVisual(self)
	}
	method ocultar() {
		gameEngine.removeVisual(self)
	}
}

class Texto inherits Visual {
	var property text
	const property textColor
	override method initialize() {
		super()
	}
}
class Imagen inherits Visual {
	var image
	method image() = image
	method image(_path) {
		image = _path
	}
	override method initialize() {
		super()
	}
}

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
	var prev_dt
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
			prev_dt = dt_global // guardamos su estado actual
			dt_global *= 10	// cambiamos su valor
			game.onTick(dt_global, "actualizar", { self.update(prev_dt/2) })
			gameEngine.restartAllOnTickEvents()
			console.println("Camara lenta activada")
			
			sonidos.startSlowMotionIn_SFX()
			 
		}
		enCamaraLenta = true
	}
	method desactivarCamaraLenta() {
		if (enCamaraLenta) {
			self.stop()
			dt_global = prev_dt // restauramos el valor de dt_global
			self.start(prev_dt) // volvemos a empezar el updater con los valores viejos
			gameEngine.restartAllOnTickEvents()
			console.println("Camara lenta desactivada")
			
			sonidos.startSlowMotionOut_SFX()
		}
		enCamaraLenta = false
	}
	method toggleCamaraLenta() {
		if (enCamaraLenta) {
			self.desactivarCamaraLenta()	
		} else {
			self.activarCamaraLenta()
		}
		console.println("dt changed to:"+ dt_global)
	}
}

class OnTickEvent {
	const property time
	const property name
	const property block
}

object sonidos {
	const property musica = game.sound("assets/SONIDOS/musica.mp3")
	
	method playSound(path, volume) {
		const sonido = game.sound(path)
		sonido.volume(0.1)
		sonido.play()
	}
	
	method startMusic() {
		musica.shouldLoop(true)
		musica.volume(0.1)
		game.schedule(500, { musica.play()} )
	}
	
	method startSlowMotionIn_SFX() {
		const slowMotionIn = game.sound("assets/SONIDOS/cl-in.mp3")
		musica.volume(0.05)
		slowMotionIn.volume(0.5)
		game.schedule(1000, {musica.pause()})
//		self.musica().pause()
		slowMotionIn.play()	
	}
	method startSlowMotionOut_SFX() {
		const slowMotionOut = game.sound("assets/SONIDOS/cl-out.mp3") 
		game.schedule(2500, {musica.resume()})
		slowMotionOut.play()
		musica.volume(0.1)
	}
}


object gameEngine {
	const property allOnTicksEvents = new Set()
	const property objetosVisibles = new Set()
	
	const property objetos = new Set()
	const property enemigos = new Set()
	const property proyectilesEnemigos = new Set()
	const property proyectilesJugador = new Set()
	const property consumibles = new Set()
	var property jugador = null
	
	

	method jugador(_jugador) {
		jugador = _jugador
	}
	
	method schedule(time, block) { // falta hacer que la camara lenta lo afecte
		game.schedule(time*updater.dt_global(), block)
	}
	method onTick(time, name, block) {
		allOnTicksEvents.add(new OnTickEvent(time=time, name=name, block=block))
		game.onTick(time*updater.dt_global(), name, block)
	}
	method restartAllOnTickEvents() {
		allOnTicksEvents.forEach { onTickEvent =>
			const time = onTickEvent.time()
			const name = onTickEvent.name()
			const block = onTickEvent.block()
			self.removeTickEvent(name)
			self.onTick(time, name, block) 
		}
	}
	method removeTickEvent(name) {
		console.println("BUSCANDO: "+name)
		try {
			const onTickEvent = allOnTicksEvents.find({ onTickEvent => onTickEvent.name() == name })
			game.removeTickEvent(name)
			allOnTicksEvents.remove(onTickEvent)
			console.println("ELIMINADO: "+name)
			
		} catch e : ElementNotFoundException {
			console.println("El OnTickEvent \""+name+"\" no existe actualmente.")
		}
	}
	method removeVisual(objeto) {
		const nombre = objeto.toString()+objeto.identity()
		console.println("BUSCANDO: "+nombre)
		if (objetosVisibles.contains(objeto)) {
			game.removeVisual(objeto)
			objetosVisibles.remove(objeto)
			console.println("ELIMINADO: "+nombre)
		} 
		else {
			console.println("El visual \""+nombre+"\" no existe actualmente.")
		}
	}
	method addVisual(objeto) {
		game.addVisual(objeto)
		objetosVisibles.add(objeto)
	}
	method say(objeto, texto) {
		if (objetos.contains(objeto)) {
			game.say(objeto, texto)			
		}
	}
}