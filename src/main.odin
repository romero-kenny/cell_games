package game

import "./cell_game"
import eg "./example_games"

main :: proc() {
	cell_game.game_init("game_of_life", eg.GolCell, eg.gol_game_module_setup())
}
