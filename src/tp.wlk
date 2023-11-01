import wollok.game.*

import global.*
import vectores.*
import mapa.*


object tpIntegrador {
	method iniciar() {
	  	
	  	mapa.iniciar()

		// empezar el actualizador global
		updater.start()
	}	
}