import wollok.game.*
import jugador.*

class ObjetoDeJuego {

//Los metodos abstractos entre las dos clases
//	method perder()
	method danio()

	method nombreEvento()

	method tiempoEvento()

	method colision()

}

class Enemigo inherits ObjetoDeJuego {

	var property position = self.dondeAparece()
	var property danio = 1
//	var property vueltas = 0
//	const vueltasLimites = 3.randomUpTo(5).roundUp()
	var property tiempoCambio = self.tiempoEvento()

	method dondeAparece() {
		return new Position(x = game.width() - 1, y = 3.randomUpTo(game.height() - 3))
	}

	method crear() {
		position = self.dondeAparece()
		game.addVisual(self)
		game.onTick(self.tiempoEvento(), self.nombreEvento(), { self.mover()})
	}

	method mover() {
		self.llegarAlFin()
	}

	method llegarAlFin() {
		if (self.position().x() != 0) {
			position = position.left(1)
		} else {
			jugador.puntos(jugador.puntos() + 10)
			self.darVuelta()
		}
	}

//	method pasaElLimite() {
//		if (vueltas >= vueltasLimites) {
//			if (tiempoCambio > 200) {
//				tiempoCambio = tiempoCambio - 100
//				game.removeTickEvent(self.nombreEvento())
//				game.onTick(tiempoCambio, self.nombreEvento(), { self.mover()})
//			}
//			vueltas = 0
//		}
//	}
	method darVuelta() {
		// hacer que de una vuelta y que pasando vueltasLimites se mueva mas rapido
		position = self.dondeAparece()
//		vueltas += 1
//		self.pasaElLimite()
	}

//	override method perder() {
//		if (game.hasVisual(self)) {
//			game.removeVisual(self)
//		}
//		game.removeTickEvent(self.nombreEvento())
//		self.position(self.dondeAparece())
//	}
	override method colision() {
//		game.removeVisual(self)
//		game.removeTickEvent(self.nombreEvento())
		position = self.dondeAparece()
//		self.crear()
		jugador.estado()
	}

}

//el tigre es mas rapido
class Tigre inherits Enemigo {

	const property image = "tigre.png"

	override method nombreEvento() = "moverTigre"

	override method tiempoEvento() = 500

}

// si el jugador tiene armadura la destruye
class Elefante inherits Enemigo {

	const property image = "elefante.png"

	override method nombreEvento() = "moverElefante"

	override method tiempoEvento() = 1000

	override method danio() {
		if (jugador.armaduraCantidad() > 0) {
			return jugador.armaduraCantidad()
		} else {
			return danio * 3
		}
	}

}

// el gorila vuelve a aparecer en la fila donde esta el jugador
class Gorila inherits Enemigo {

	const property image = "gorila.png"

	override method nombreEvento() = "moverGorila"

	override method tiempoEvento() = 800

	override method danio() {
		return danio * 2
	}

	override method dondeAparece() {
		return new Position(x = game.width() - 1, y = jugador.position().y())
	}

}

class CreadorEnemigos {

	const coleccionDeEnemigos = [ new Tigre(), new Elefante(), new Gorila() ]

	method crear() {
		coleccionDeEnemigos.forEach({ e =>
			if (!game.hasVisual(e)) {
				e.crear()
			}
		})
	}

//	method perder() {
//		coleccionDeEnemigos.forEach({ e => e.perder()})
//	}
}

//Objetos Extras
class Extra inherits ObjetoDeJuego {

//	var creado = false
	var property position

	override method danio() = 0

	method crearExtra() {
		if (!game.hasVisual(self)) {
			position = self.posicion()
			game.addVisual(self)
//			creado = true
		} else {
			game.removeTickEvent(self.nombreEvento())
//			creado = false
		}
	}

	method posicion() {
		return self.lugarEnPantalla()
	}

	method lugarEnPantalla() {
		return new Position(x = 3.randomUpTo(game.width() - (game.width() / 3) - 2), y = 3.randomUpTo(game.height() - 3))
	}

//	override method perder() {
//		if (game.hasVisual(self)) {
//			game.removeVisual(self)
//		} else {
//			game.removeTickEvent(self.nombreEvento())
//		}
//	}
	method crearTick() {
		if (!game.hasVisual(self)) {
			game.onTick(self.tiempoEvento(), self.nombreEvento(), { self.crearExtra()})
		}
	}

}

object armadura inherits Extra {

	const property image = "armor.png"

	override method nombreEvento() = "Armadura"

	override method tiempoEvento() = 7000

	override method colision() {
//		game.say(jugador, self.nombreEvento())
		game.removeVisual(self)
		self.crearTick()
		jugador.armaduraCantidad(5)
		barraDeArmadura.removerDePantalla()
		jugador.image("scoutArmor.png")
//		self.equiparArmadura()
	}

	method equiparArmadura() {
//		jugador.armor(true)
//		jugador.armaduraCantidad+ (5)
//		barraDeArmadura.removerDePantalla()
//		jugador.image("scoutArmor.png")
	}

}

object vida inherits Extra {

	const property image = "hp.png"

	override method nombreEvento() = "Vida"

	override method tiempoEvento() = 3000

	override method colision() {
//		jugador.vidaJugador(jugador.vidaJugador() + 10)
//		if (jugador.vidaJugador() > 100) {
//			jugador.vidaJugador(100)
//			game.say(jugador, "Tengo la vida máxima")
//		} else {
//			game.say(jugador, "Vida recuperada")
//		}
//		game.say(jugador, self.nombreEvento())
		game.removeVisual(self)
		self.crearTick()
		jugador.vidaJugador(5)
		barraDeVida.removerDePantalla()
	}

}

object score {

	method calcularPuntos() = (jugador.vidaJugador() + jugador.armaduraCantidad()) * 100

	method ganarPuntos() {
		jugador.puntos(jugador.puntos()+self.calcularPuntos())
	}

	method puntuacionTotal() = jugador.puntos()

}

