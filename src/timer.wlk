import wollok.game.*

class Clock { 
	const timeUnit = ms // ms | s | h 
	var elapsed_time_ms = 0
	
	method start() {
		game.onTick(1, "ms", { elapsed_time_ms++ }) // contar cada milisegundo que pasa desde que se iniciar el contador
	}
	
	method stop() = elapsed_time_ms
	
}

object ms { // milisegundos
	
}

object s { // segundos 
	
}

object h { // hora
	
}
