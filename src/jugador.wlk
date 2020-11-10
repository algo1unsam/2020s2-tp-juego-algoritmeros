import wollok.game.*
import enemigos.*
import configuracion.*
import graficos.*

object jugador {

	var property image = "scout.png"
	var property vidaJugador = 5
	var property position = new Position(x = 3, y = 3)
	var direccion = quieto
	var property armaduraCantidad = 0
	var property puntos = 0

	method movimiento(direccionModificar) {
		direccion = direccionModificar
	}

	method mover() {
		if (self.position().y() == game.height() - 2) {
			direccion = quieto
			position = position.down(1)
		} else if (self.position().y() == 2) {
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

	method danioVida(danio, enem) {
		if (!(armaduraCantidad == 0)) {
			armaduraCantidad -= danio
		} else {
			vidaJugador -= danio
		}
		if (armaduraCantidad == 0) {
			self.image("scout.png")
		}
		enem.colision()
	}

	method estado() {
		if (!gameOver.perdio()) {
			barraDeVida.removerDePantalla()
			barraDeArmadura.removerDePantalla()
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
		game.addVisual(jugadorScoreCartel)
		self.repetirMensaje()
		configuracion.teclado()
	}

	method repetirMensaje() {
		game.say(jugadorScoreCartel, "Obtuviste " + jugador.puntos().toString() + " puntos")
		game.say(jugadorScoreCartel, "Presiona Enter para reiniciar")
	}

}

