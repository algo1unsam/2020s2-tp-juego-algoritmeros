import wollok.game.*
import jugador.*
//cambio a clase
//PROBLEMA:pasarlo a clase hace que el enemigo aparezca en el jugador al iniciar
class Enemigo {

// se mueve en el eje y del jugador
	var vueltas=0
	const vueltasLimites=1//3.randomUpTo(5)
	const property tiempoBase = 500
	var tiempoCambia=tiempoBase
	const property image = "tigre.png"
	//agregué el daño/dmg a los enemigos
	var dmg = null
	//ahora la posicion en la que aparece en Y es random y en la que se mueve al dar la vuelta tmb
	var property position = new Position(x = game.width()-1, y = 0.randomUpTo(game.height()-1))

	method mover() {
		if (self.position().x() != 0) {
			position = position.left(1)
		} else {
			//hacer que de una vuelta y que con cada vuelta se mueva mas rapido
			position = new Position(x = game.width() - 1, y = 0.randomUpTo(game.height()-1))
			vueltas+=1
			if(vueltas>=vueltasLimites){
				
				if(tiempoCambia>100){
					tiempoCambia=tiempoCambia-50
				}
				game.say(jugador,tiempoCambia.toString())//para saber si cambia de velocidad el enemigo
				game.removeTickEvent("moverEnemigo1")
				game.onTick(tiempoCambia, "moverEnemigo1", { self.mover()})
				vueltas=0
			}
		}
	}
	
	method atacar(){
		jugador.vida(jugador.vida()-dmg)
	}

}

//object enemigo2 {

//se mueve en un y random
	//const property image = "tigre.png"
	//var property position = new Position(x = game.width() - 1, y = 0.randomUpTo(game.height()))

	//method mover() {
		//if (self.position().x() != 0) {
			//position = position.left(1)
		//} else {
			//position = new Position(x = game.width() - 1, y = 0.randomUpTo(game.height()))
		//}
	//}

//}
