package main
import rl "vendor:raylib"
import cg "./cell_games"
import gr "./game_rendering"

main :: proc() {
	curr_game := cg.game_init(game_type = cg.GameType.pokemon_auto_battler)
	window_info := gr.init_window_info(&curr_game)
	cg.random_game_space(&curr_game)
	gr.initialize_window(&curr_game, &window_info)
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		cg.game_play(&curr_game)
		gr.game_draw(&curr_game, &window_info)
	}
}
