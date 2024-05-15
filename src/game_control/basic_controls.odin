package game_control

import cg "../cell_games"
import rl "vendor:raylib"

pause_game :: proc(game: ^cg.Game) {
	if rl.IsKeyPressed(rl.KeyboardKey.SPACE) {
		game.tick_rate.pause = !game.tick_rate.pause
	}
}

speed_up_game :: proc(game: ^cg.Game) {
	if rl.IsKeyPressed(rl.KeyboardKey.RIGHT_BRACKET) {
		game.tick_rate.curr_tick_rate /= 1.5
	}
}

slow_down_game :: proc(game: ^cg.Game) {
	if rl.IsKeyPressed(rl.KeyboardKey.LEFT_BRACKET) {
		game.tick_rate.curr_tick_rate *= 1.5
	}
}

check_controls :: proc(game: ^cg.Game) {
	pause_game(game)
	speed_up_game(game)
	slow_down_game(game)
}
