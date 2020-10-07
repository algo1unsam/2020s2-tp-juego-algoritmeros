import wollok.game.*

object jugador {

	const property image = "scout.png"
	var property position = new Position(x = 3, y = 3)
	var direccion = quieto
	//var dirAnterior = null

	method movimiento(direccionModificar) {
		
		direccion = direccionModificar
	// probando detener al personaje al tocar otra tecla
	//if (direccion != dirAnterior and dirAnterior != null) {
	 //game.removeTickEvent("mover")
	 //dirAnterior = null
	 //} else {
	 //dirAnterior=direccion
	 //}
	}

	method mover() {
		// cambie la logica para que use el alto y ancho del juego
		
		if (self.position().y() == game.height() - 1) {
			direccion = quieto
			position = position.down(1)
		} else if (self.position().y() == 0) {
			direccion = quieto
			position = position.up(1)
		} else if (self.position().x() == 0) {
			direccion = quieto
			position = position.right(1)
		} else if (self.position().x() == game.width() - 5) {
			direccion = quieto
			position = position.left(1)
		} else {
			position = direccion.position()
		}
	}

}

object abajo {

	method position() = jugador.position().down(1)

}

object arriba {

	method position() = jugador.position().up(1)

}

object izq {

	method position() = jugador.position().left(1)

}

object der {

	method position() = jugador.position().right(1)

}

object quieto {

	method position() = jugador.position()

}

