import wollok.game.*

object jugador {
	
	// const property image = if (armor) "scout.png" else "scout.png"
	const property image = "scout.png"
	var property vida = 100
	var property position = new Position(x = 3, y = 3)
	var direccion = quieto
	// agregue la var armadura. La idea es que dependiendo de la armadura que tenga el personaje se pueda aguantar X cantidad de golpes sin que le baje la vida
	var property armor = false
	var property armadura = 0
	var danioTotal

	method movimiento(direccionModificar) {
		direccion = direccionModificar
	}

	method mover() {
		if (self.position().y() == game.height() - 1) {
			direccion = quieto
			position = position.down(1)
		} else if (self.position().y() == 0) {
			direccion = quieto
			position = position.up(1)
		} else if (self.position().x() == 0) {
			direccion = quieto
			position = position.right(1)
		} else if (self.position().x() == game.width() - game.width()/3.roundUp()) {
			direccion = quieto
			position = position.left(1)
		} else {
			position = direccion.position()
		}
	}
	//armadura reduce el daño de la vida a la mitad, y recibe todo el daño
	method danioVida(danio) {
		if (danio != 0) {
			if (armor) {
				danioTotal = (danio / 2).roundUp()
				vida -= danioTotal
				armadura -= danio
				self.estado()
				if(armadura<=0){
					armor=false
					armadura=0
				}
			} else {
				vida -= danio
				self.estado()
			
		}
	}

}

	method agarrar(extra) {
		extra.efecto()
		
	}
	method agarrarArm(){
		armor=true
		armadura=100
	}
	
	method estado(){
		if(armor){
		game.say(self, "Tengo " + self.vida().toString() + " de vida restante y "+self.armadura().toString()+" de armadura")
	}else{
		game.say(self, "Tengo " + self.vida().toString() + " de vida restante")
	}}
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

