import wollok.game.*
import jugador.*

class Enemigo {

	var vueltas = 0
	const vueltasLimites = 3.randomUpTo(5).roundUp()
	const property tiempoBase
	var tiempoCambia = tiempoBase
	const property image
	var property danio
	var property position = new Position(x = game.width() - 1, y = 0.randomUpTo(game.height() - 1))

	method mover() {
		if (self.position().x() != 0) {
			position = position.left(1)
		} else {
			// hacer que de una vuelta y que con cada vuelta se mueva mas rapido
			position = new Position(x = game.width() - 1, y = 0.randomUpTo(game.height() - 1))
			vueltas += 1
			if (vueltas >= vueltasLimites) {
				if (tiempoCambia > 100) {
					tiempoCambia = tiempoCambia - 50
				}
				game.say(jugador, tiempoCambia.toString()) // para saber si cambia de velocidad el enemigo
				game.removeTickEvent("moverEnemigo1")
				game.onTick(tiempoCambia, "moverEnemigo1", { self.mover()})
				vueltas = 0
			}
		}
	}

}

object creadorEnemigos {

	const enem = [ 
		new Enemigo(danio = 5, image="tigre.png", tiempoBase=500), 
		new Enemigo(danio = 10, image="elefante.png", tiempoBase = 700)//, 
		//new Enemigo(danio=15, image="gorila.png", tiempoBase = 600)
	]

	method crear() {
		enem.forEach({ x => game.addVisual(x)})
		enem.forEach({ x => game.onTick(x.tiempoBase(), "moverEnemigo1", { x.mover()})})
	}

}

 //Error null does not understand >