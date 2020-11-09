import wollok.game.*
import enemigos.*
import configuracion.*

object jugador {

	var property image = "scout.png"
	var property vidaJugador = 5
	var property position = new Position(x = 3, y = 3)
	var direccion = quieto
//	var property armor = false
	var property armaduraCantidad = 0
	var property puntos = 0

	// var danioTotal
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

	// FIXEE LOS CARTELES PARA QUE NO MUESTRE NI VIDA NI ARMADURA NEGATIVA
	method danioVida(danio, enem) {
//		if (danio != 0) {
		if (!(armaduraCantidad == 0)) {
			armaduraCantidad -= danio
//				}else if (armaduraCantidad <= 0) {
//					armor = false
//					armaduraCantidad = 0
//					self.image("scout.png")
//				}
		} else {
			vidaJugador -= danio
		}
		if (armaduraCantidad == 0) {
			self.image("scout.png")
		}
//		}
		enem.colision()
//		self.estado()
	}

//	method agarrarObjeto(ex) {
//		ex.efecto()
//	}
	method estado() {
		if (!gameOver.perdio()) {
			barraDeVida.removerDePantalla()
			barraDeArmadura.removerDePantalla()
//			game.say(self, "Tengo " + self.vidaJugador().toString() + " de vida restante y " + self.armaduraCantidad().toString() + " de armadura")
//		} else if (!gameOver.perdio()) {
//			game.say(self, "Tengo " + self.vidaJugador().toString() + " de vida restante")
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
		game.say(gameOver, jugador.puntos().toString())
		jugador.puntos(0)
		configuracion.teclado()
	// El sonido funciona pero creo que esta muy alto 
//	 	game.sound("sounds/gameOver.mp3").play()
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
		self.actualizarBarra().times({ i => coleccionDeBarra.add(new ArmaduraJugador(position = new Position(x = 5 + i - 1, y = game.height() - 1)))})
	}

	override method actualizarBarra() {
		return jugador.armaduraCantidad()
	}

}

//object fondo1 {
// var property image = "primera.png"
// var property position = new Position(x = 0, y = 0)
//}
//object fondo2 {
// var property image = "segunda.png"
// var property position = new Position(x = 0, y = 0)
//}
