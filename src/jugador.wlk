import wollok.game.*

object jugador {

	var property image = "scout.png"
	var property vida = 10
	var property position = new Position(x = 3, y = 3)
	var direccion = quieto
	var property armor = false
	var property armadura = 0
	var danioTotal

	method movimiento(direccionModificar) {
		direccion = direccionModificar
	}

	method mover() {
		if (self.position().y() == game.height() - 1) {
			direccion = quieto
			position = position.down(1)
		} else if (self.position().y() == 0) {
			direccion = quieto
			position = position.up(1)
		} else if (self.position().x() == 0) {
			direccion = quieto
			position = position.right(1)
		} else if (self.position().x() == game.width() - game.width() / 3.roundUp()) {
			direccion = quieto
			position = position.left(1)
		} else {
			position = direccion.position()
		}
	}

	// FIXEE LOS CARTELES PARA QUE NO MUESTRE NI VIDA NI ARMADURA NEGATIVA
	method danioVida(danio) {
		if (danio != 0) {
			if (armor) {
				//danioTotal = (danio / 2).roundUp()
				//vida -= danioTotal
				armadura -= danio
				if (armadura <= 0) {
					armor = false
					armadura = 0
					self.image("scout.png")
				}
			} else {
				vida -= danio
			}
		}
		self.estado()
	}

	method agarrar(extra) {
		extra.efecto()
	}

	method agarrarArm() {
		armor = true
		armadura = 100
		self.image("scoutArmor.png")
	}

	method estado() {
		if (!gameOver.perdio() and armor) {
			game.say(self, "Tengo " + self.vida().toString() + " de vida restante y " + self.armadura().toString() + " de armadura")
		} else if (!gameOver.perdio()) {
			game.say(self, "Tengo " + self.vida().toString() + " de vida restante")
		} else {
			perdiste.finJuego()
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

object perdiste {

	method finJuego() {
		game.clear()
		game.addVisual(gameOver)
	}

}

object gameOver {

	var property image = "gameOver.png"
	var property position = new Position(x = 0, y = 0)

	method perdio() = jugador.vida() <= 0

}

//object fondo1 {
	//var property image = "primera.png"
	//var property position = new Position(x = 0, y = 0)
//}

//object fondo2 {
	//var property image = "segunda.png"
	//var property position = new Position(x = 0, y = 0)
//}

