package game

import "./cell_game"

main :: proc() {
	curr_game := game_init(
		game_type = GameType.pokemon_auto_battler,
	)
	initialize_window(&curr_game)
	defer rl.CloseWindow()
	random_game_space(&curr_game, poke_random_game)

	for !rl.WindowShouldClose() {
		if check_tick(&curr_game) {
			game_logic(&curr_game)
		}
		game_draw(&curr_game)
	}
}
