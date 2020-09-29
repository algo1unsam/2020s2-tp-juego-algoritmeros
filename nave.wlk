import wollok.game.*

object nave {

	const property image = "nave.png"
	var property position = new Position(x = 3, y = 3)
	var direccion = quieto

	method movimiento(direccionModificar) {
		direccion = direccionModificar
	}

	method mover() {
		position = direccion.position()
	}

}

object abajo {

	method position() = nave.position().down(1)

}

object arriba {

	method position() = nave.position().up(1)

}

object izq {

	method position() = nave.position().left(1)

}

object der {

	method position() = nave.position().right(1)

}

object quieto {

	method position() = nave.position()

}

