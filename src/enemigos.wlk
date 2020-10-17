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
	const vueltasLimites = 1 // 3.randomUpTo(5).roundUp()
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
					game.removeTickEvent("moverEnemigo1")
					game.onTick(tiempoCambia, "moverEnemigo1", { self.mover()})
				}
				vueltas = 0
			}
		}
	}

}

//PROBLEMA :El elefante se detiene despues de un rato
class Elefante inherits Enemigo {

	const property image = "elefante.png"
	
	// si tiene armadura la destruye
	override method danio() {
		if (jugador.armor()) {
			return jugador.armadura()
		} else {
			return danio * 2
		}
	}

}

object creadorEnemigos {

	const enem = [ new Tigre(), new Elefante() ]

	method crear() {
		enem.forEach({ x => game.addVisual(x)})
		enem.forEach{ x => game.onTick(x.tiempoBase(), "moverEnemigo1", { x.mover()})}
	}

}

//Objetos Extras
//Probable que necesite cambiar a clase
//Talvez mas objetos: algo que recupere vida y otro que de puntos
object extra {

	const property image = "pepita.png"
	var creado = false
	var property position= new Position(x=3.randomUpTo(game.width()-(game.width()/3)-2),y=3.randomUpTo(game.height()-3))
	method crearExtra() {
		if (!creado) {
			position= new Position(x=3.randomUpTo(game.width()-(game.width()/3)-2),y=3.randomUpTo(game.height()-3))
			game.addVisual(self)
			creado = true
		} else {
			game.removeTickEvent("ex")
			creado = false
		}
	}

	method efecto() {
		game.say(jugador, "Armadura")
		game.removeVisual(self)
		game.onTick(1000, "ex", { self.crearExtra()})
		jugador.agarrarArm()
	}

	method danio() {
		return 0
	}

}

