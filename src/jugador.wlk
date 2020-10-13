import wollok.game.*

object jugador {

	// const property image = if (armor) "scout.png" else "scout.png"
	const property image = "scout.png"
	var property vida = 100
	var property position = new Position(x = 3, y = 3)
	var direccion = quieto
	// agregue la var armadura. La idea es que dependiendo de la armadura que tenga el personaje se pueda aguantar X cantidad de golpes sin que le baje la vida
	var armor = false

	method movimiento(direccionModificar) {
		direccion = direccionModificar
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

	method danioVida(danio) {
		vida = vida - danio
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

