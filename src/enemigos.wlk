import wollok.game.*
import jugador.*

class ObjetoDeJuego {

//Los metodos abstractos entre las dos clases
	method efecto()

	method perder()

	method danio()

	method nombreEvento()

	method tiempoEvento()

}

class Enemigo inherits ObjetoDeJuego {

	var property position = self.dondeAparece()
	var property danio = 5
	var property vueltas = 0
	const vueltasLimites = 3.randomUpTo(5).roundUp()
	var property tiempoCambio = self.tiempoEvento()

	override method efecto() {
	}

	method dondeAparece() {
		return new Position(x = game.width() - 1, y = 0.randomUpTo(game.height() - 1))
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
			self.darVuelta()
		}
	}

	method pasaElLimite() {
		if (vueltas >= vueltasLimites) {
			if (tiempoCambio > 200) {
				tiempoCambio = tiempoCambio - 100
				game.removeTickEvent(self.nombreEvento())
				game.onTick(tiempoCambio, self.nombreEvento(), { self.mover()})
			}
			vueltas = 0
		}
	}

	method darVuelta() {
		// hacer que de una vuelta y que pasando vueltasLimites se mueva mas rapido
		position = self.dondeAparece()
		vueltas += 1
		self.pasaElLimite()
	}

	override method perder() {
		if (game.hasVisual(self)) {
			game.removeVisual(self)
		}
		game.removeTickEvent(self.nombreEvento())
		self.position(self.dondeAparece())
	}

	method colision() {
		game.removeVisual(self)
		game.removeTickEvent(self.nombreEvento())
		position = self.dondeAparece()
		self.crear()
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

	override method tiempoEvento() = 800

	override method danio() {
		if (jugador.armor()) {
			return jugador.armaduraCantidad()
		} else {
			return danio * 4
		}
	}

}

// el gorila vuelve a aparecer en la fila donde esta el jugador
class Gorila inherits Enemigo {

	const property image = "gorila.png"

	override method nombreEvento() = "moverGorila"

	override method tiempoEvento() = 600

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
//	method perder2() {
//		coleccionDeEnemigos2.forEach({ e => e.perder()})
//	}
//
}

//Objetos Extras
//Talvez mas objetos: algo que recupere vida y otro que de puntos
class Extra inherits ObjetoDeJuego {

	var creado = false
	var property position

	override method danio() = 0

	method crearExtra() {
		if (!creado) {
			position = self.posicion()
			game.addVisual(self)
			creado = true
		} else {
			game.removeTickEvent(self.nombreEvento())
			creado = false
		}
	}

	method posicion() {
		return self.lugarEnPantalla()
	}

	method lugarEnPantalla() {
		return new Position(x = 3.randomUpTo(game.width() - (game.width() / 3) - 2), y = 3.randomUpTo(game.height() - 3))
	}

	override method perder() {
		if (game.hasVisual(self)) {
			game.removeVisual(self)
		} else {
			game.removeTickEvent(self.nombreEvento())
		}
	}

	method crearTick() {
		if (!game.hasVisual(self)) {
			game.onTick(self.tiempoEvento(), self.nombreEvento(), { self.crearExtra()})
		}
	}

}

object armadura inherits Extra {

	const property image = "armor.png"

	override method nombreEvento() = "Armadura"

	override method tiempoEvento() = 5000

	override method efecto() {
		game.say(jugador, self.nombreEvento())
		game.removeVisual(self)
		self.crearTick()
		self.equiparArmadura()
	}

	method equiparArmadura() {
		jugador.armor(true)
		jugador.armaduraCantidad(100)
		jugador.image("scoutArmor.png")
	}

}

object vida inherits Extra {

	const property image = "hp.png"

	override method nombreEvento() = "Vida"

	override method tiempoEvento() = 1000

	override method efecto() {
		jugador.vidaJugador(jugador.vidaJugador() + 10)
		if (jugador.vidaJugador() > 100) {
			jugador.vidaJugador(100)
			game.say(jugador, "Tengo la vida máxima")
		} else {
			game.say(jugador, "Vida recuperada")
		}
		game.removeVisual(self)
		self.crearTick()
	}

}

