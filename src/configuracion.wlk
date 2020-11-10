import wollok.game.*
import jugador.*
import enemigos.*
import graficos.*

object configuracion {

	method inicio() {
		game.title("Jumanji")
		game.height(10)
		game.width(15)
		game.boardGround("calle.png")
		game.addVisual(primera)
	}

	method teclado() {
		keyboard.enter().onPressDo({ self.manejarPantalla()})
	}

	method manejarPantalla() {
		self.primeraPantalla()
		if (game.hasVisual(gameOver)) {
			game.removeVisual(jugadorScoreCartel)
			game.removeVisual(gameOver)
			game.addVisual(primera)
		}
	}

	method primeraPantalla() {
		if (game.hasVisual(primera)) {
			game.removeVisual(primera)
			self.crearJugador()
				// Grupos de enemigos, pueden ser mas si necesario
			const grupo1 = new CreadorEnemigos()
			const grupo2 = new CreadorEnemigos()
			const grupo3 = new CreadorEnemigos()
			grupo1.crear()
				// Los otros grupos aparecen despues de cierto tiempo
			game.schedule(10000, { grupo2.crear()})
			game.schedule(20000, { grupo3.crear()})
		}
	}

	method crearJugador() {
		if (!game.hasVisual(jugador)) {
			game.addVisual(jugador)
			jugador.position(new Position(x = 3, y = 3))
			jugador.movimiento(quieto)
			jugador.vidaJugador(5)
			jugador.puntos(0)
			barraDeVida.dibujarEnPantalla()
			barraDeArmadura.dibujarEnPantalla()
			self.movimientoJugador()
			self.tickExtras()
			self.colides()
		}
	}

	// CONTROLES
	method movimientoJugador() {
		game.onTick(150, "mover", { jugador.mover()})
		self.moverJugador()
	}

	method moverJugador() {
		keyboard.w().onPressDo({ jugador.movimiento(arriba)})
		keyboard.s().onPressDo({ jugador.movimiento(abajo)})
		keyboard.a().onPressDo({ jugador.movimiento(izq)})
		keyboard.d().onPressDo({ jugador.movimiento(der)})
		keyboard.space().onPressDo({ jugador.movimiento(quieto)})
	}

	// EXTRAS
	method tickExtras() {
		game.onTick(armadura.tiempoEvento(), armadura.nombreEvento(), { armadura.crearExtra()})
		game.onTick(vida.tiempoEvento(), vida.nombreEvento(), { vida.crearExtra()})
		game.onTick(10000, "sumarPuntos", { score.ganarPuntos()})
	}

	method colides() {
		game.onCollideDo(jugador, { enem => jugador.danioVida(enem.danio(), enem)})
	}

}

