import wollok.game.*
import jugador.*

class Enemigo {

	var property position = new Position(x = game.width() - 1, y = 0.randomUpTo(game.height() - 1))
	var property danio = 5
	var property tiempoBase = 500

	method mover() {
		if (self.position().x() != 0) {
			position = position.left(1)
		} else {
			// hacer que de vueltas
			position = new Position(x = game.width() - 1, y = 0.randomUpTo(game.height() - 1))
		}
	}

	// necesario debido a que los objetos extras tienen estos metodos
	method efecto() {
	}

	method agarrar() {
	}

}

class Tigre inherits Enemigo {

	const property image = "tigre.png"
	var vueltas = 0
	const vueltasLimites = 3.randomUpTo(5).roundUp()
	var tiempoCambia = tiempoBase

	override method mover() {
		if (self.position().x() != 0) {
			position = position.left(1)
		} else {
			// hacer que de una vuelta y que con cada vuelta se mueva mas rapido
			position = new Position(x = game.width() - 1, y = 0.randomUpTo(game.height() - 1))
			vueltas += 1
			if (vueltas >= vueltasLimites) {
				if (tiempoCambia > 200) {
					tiempoCambia = tiempoCambia - 100
					game.removeTickEvent("moverTigre")
					game.onTick(tiempoCambia, "moverTigre", { self.mover()})
				// creadorEnemigos.enem().forEach{ x => game.onTick(tiempoCambia, "moverEnemigo1", { x.mover()})}
				}
				vueltas = 0
			}
		}
	}

}

//PROBLEMA :El elefante se detiene despues de un rato
class Elefante inherits Enemigo {

	const property image = "elefante.png"
	var vueltas = 0
	const vueltasLimites = 3.randomUpTo(5).roundUp()
	var tiempoCambia = tiempoBase

	// si tiene armadura la destruye
	override method danio() {
		if (jugador.armor()) {
			return jugador.armadura()
		} else {
			return danio * 4
		}
	}

	override method mover() {
		if (self.position().x() != 0) {
			position = position.left(1)
		} else {
			position = new Position(x = game.width() - 1, y = 0.randomUpTo(game.height() - 1))
			vueltas += 1
			if (vueltas >= vueltasLimites) {
				if (tiempoCambia > 300) {
					tiempoCambia = tiempoCambia - 100
					game.removeTickEvent("moverElefante")
					game.onTick(tiempoCambia, "moverElefante", { self.mover()})
				}
				vueltas = 0
			}
		}
	}

}

//object creadorEnemigos {
// const property enem = [ new Tigre(), new Elefante(tiempoBase = 800) ]
// method crear() {
// enem.forEach({ x => game.addVisual(x); game.onTick(x.tiempoBase(), "moverEnemigo1", { x.mover()})})
// enem.forEach{ x => game.onTick(x.tiempoBase(), "moverEnemigo1", { x.mover()})}
// }
//}
// CAMBIE EL CREADOR DE ENEMIGOS A ALGO FIJO PARA USAR LOS DISTINTOS TICKS
object creadorEnemigos {

	const tigre = new Tigre()
	const elefante = new Elefante(tiempoBase = 800)

	method crear() {
		game.addVisual(tigre)
		game.addVisual(elefante)
		game.onTick(tigre.tiempoBase(), "moverTigre", { tigre.mover()})
		game.onTick(elefante.tiempoBase(), "moverElefante", { elefante.mover()})
	}

}

//Objetos Extras
//Probable que necesite cambiar a clase
//Talvez mas objetos: algo que recupere vida y otro que de puntos
object extra {

	const property image = "armor.png"
	var creado = false
	var property position

	method crearExtra() {
		if (!creado) {
			position = new Position(x = 3.randomUpTo(game.width() - (game.width() / 3) - 2), y = 3.randomUpTo(game.height() - 3))
			if (self.position() != jugador.position() and self.position() != vida.position()) {
				game.addVisual(self)
				creado = true
			}
		} else {
			game.removeTickEvent("armadura")
			creado = false
		}
	}

	method efecto() {
		game.say(jugador, "Armadura")
		game.removeVisual(self)
		game.onTick(1000, "armadura", { self.crearExtra()})
		jugador.agarrarArm()
	}

	method danio() {
		return 0
	}

}

object vida {

	const property image = "hp.png"
	var creado = false
	var property position

	method crearExtra() {
		if (!creado) {
			position = new Position(x = 3.randomUpTo(game.width() - (game.width() / 3) - 2), y = 3.randomUpTo(game.height() - 3))
			if (self.position() != jugador.position() and self.position() != extra.position()) {
				game.addVisual(self)
				creado = true
			}
		} else {
			game.removeTickEvent("curar")
			creado = false
		}
	}

	method efecto() {
		jugador.vida(jugador.vida() + 10)
		if (jugador.vida() > 100) {
			jugador.vida(100)
			game.say(jugador, "Tengo la vida máxima")
		} else {
			game.say(jugador, "Vida recuperada")
		}
		game.removeVisual(self)
		game.onTick(1000, "curar", { self.crearExtra()})
	}

	method danio() {
		return 0
	}

}

