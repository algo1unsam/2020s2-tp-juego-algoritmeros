import wollok.game.*
import jugador.*

object enemigo {

// se mueve en el eje y del jugador
	const property image = "pepita.png"
	var property position = new Position(x = game.width() - 1, y = jugador.position().y())

	method mover() {
		if (self.position().x() != 0) {
			position = position.left(1)
		} else {
			position = new Position(x = game.width() - 1, y = jugador.position().y())
		}
	}

}

object enemigo2 {

//se mueve en un y random
	const property image = "pepita.png"
	var property position = new Position(x = game.width() - 1, y = 0.randomUpTo(game.height()))

	method mover() {
		if (self.position().x() != 0) {
			position = position.left(1)
		} else {
			position = new Position(x = game.width() - 1, y = 0.randomUpTo(game.height()))
		}
	}

}

