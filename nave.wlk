import wollok.game.*

object nave {

	const property image = "nave.png"
	var property position = new Position(x = 3, y = 3)

	method movimiento(direccion) {
		game.onTick(500, "mover", { self.mover(direccion)})
	}

	method mover(direccion) {
		if (direccion == "abajo") {
			position = position.down(1)
			game.removeTick("mover")
			
		}
		if (direccion == "arriba") {
			position = position.up(1)
		}
		if (direccion == "izq") {
			position = position.left(1)
		}
		if (direccion == "der") {
			position = position.right(1)
		}
	}

}

