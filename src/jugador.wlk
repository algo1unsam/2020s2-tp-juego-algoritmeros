import wollok.game.*
import enemigos.*
import configuracion.*

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
		game.say(jugadorScoreCartel, "Obtuviste " + jugador.puntos().toString() + " puntos")
		jugador.puntos(0)
		configuracion.teclado()
	}

}

object gameOver {

	var property image = "gameOver.png"
	var property position = new Position(x = 0, y = 0)

	method perdio() = jugador.vidaJugador() <= 0

}

object primera {

	var property image = "primera.png"
	var property position = new Position(x = 0, y = 0)

}

class VidaJugador {

	var property image = "hp.png"
	var property position

	method danio() = 0

}

class ArmaduraJugador {

	var property image = "armor.png"
	var property position

	method danio() = 0

}

class Barra {

	const coleccionDeBarra = []

	method igualarBarra()

	method actualizarBarra()

	method dibujarEnPantalla() {
		self.igualarBarra()
		coleccionDeBarra.forEach({ i => game.addVisual(i)})
	}

	method removerDePantalla() {
		coleccionDeBarra.forEach({ i => game.removeVisual(i)})
		self.dibujarEnPantalla()
	}

}

object barraDeVida inherits Barra {

	var property position = new Position(x = 0, y = 0)

	override method igualarBarra() {
		coleccionDeBarra.clear()
		self.actualizarBarra().times({ i => coleccionDeBarra.add(new VidaJugador(position = new Position(x = i - 1, y = game.height() - 1)))})
	}

	override method actualizarBarra() {
		return jugador.vidaJugador()
	}

}

object barraDeArmadura inherits Barra {

	var property position = new Position(x = 0, y = 0)

	override method igualarBarra() {
		coleccionDeBarra.clear()
		self.actualizarBarra().times({ i => coleccionDeBarra.add(new ArmaduraJugador(position = new Position(x = 10 + i - 1, y = game.height() - 1)))})
	}

	override method actualizarBarra() {
		return jugador.armaduraCantidad()
	}

}

object jugadorScoreCartel {

	var property position = new Position(x = 6, y = 0)
	var property image = "scout.png"

}

