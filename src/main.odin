package cell_games

import "core:math"
import "core:time"
import rl "vendor:raylib"

GameType :: enum {
	game_of_life,
	pokemon_auto_battler,
}

CellSize :: enum {
	small  = 2,
	medium = 4,
	large  = 8,
	xlarge = 16,
}

GameSpaceSize :: enum {
	small = 25,
	medium = 50,
	large = 100,
	xlarge = 200,
	infinite,
}

TickKeeper :: struct {
	pause:          bool,
	curr_tick_rate: f64, // measured in seconds
	stopwatch:      time.Stopwatch,
}

Game :: struct {
	game_type:       GameType,
	game_space:      []Cell,
	cell_size:       CellSize,
	game_space_size: GameSpaceSize,
	tick_rate:       TickKeeper,
}

Cell :: union {
	GolCell,
	PokeCell,
}

check_tick :: proc(game: ^Game) -> (play: bool) {
	curr_tick := time.duration_seconds(time.stopwatch_duration(game.tick_rate.stopwatch))

	if game.tick_rate.pause {
		return false
	} else if game.tick_rate.curr_tick_rate > curr_tick {
		return false
	}

	time.stopwatch_reset(&game.tick_rate.stopwatch)
	time.stopwatch_start(&game.tick_rate.stopwatch)
	return true
}

initialize_window :: proc(game: ^Game) {
	window_size := i32(game.game_space_size) * i32(game.cell_size)
	game_type_string: cstring

	switch game.game_type {
	case GameType.game_of_life:
		game_type_string := "Game of Life"
	case GameType.pokemon_auto_battler:
		game_type_string := "Pokemon Auto Battler"
	}

	rl.InitWindow(window_size, window_size, game_type_string)
}

game_init :: proc(
	game_type: GameType = GameType.game_of_life,
	cell_size: CellSize = CellSize.large,
	game_space_size: GameSpaceSize = GameSpaceSize.medium,
	tick_rate: f64 = .5,
) -> (
	game: Game,
) {
	// flatten gamespace to better use memory. 
	game_size := int(game_space_size) * int(game_space_size)
	game_space := make([]Cell, game_size)
	tick_keeper := TickKeeper {
		curr_tick_rate = tick_rate,
	}

	game = Game {
		game_type       = game_type,
		cell_size       = cell_size,
		game_space      = game_space,
		game_space_size = game_space_size,
		tick_rate       = tick_keeper,
	}
	time.stopwatch_start(&game.tick_rate.stopwatch)

	return game
}

game_logic :: proc(game: ^Game) {
	switch game.game_type {
	case GameType.game_of_life:
		gol_logic_loop(game)
	case GameType.pokemon_auto_battler:
	}
}

game_draw :: proc(game: ^Game) {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.WHITE)

	switch game.game_type {
	case GameType.game_of_life:
		gol_draw_game(game)
	case GameType.pokemon_auto_battler:
	}
}

range_checker :: proc(x, y: int, game_size: GameSpaceSize) -> (correct_x, correct_y: int) {
	game_size_int := int(game_size) - 1
	if x < 0 {
		correct_x = game_size_int
	} else if x > game_size_int {
		correct_x = 0
	} else {
		correct_x = x
	}

	if y < 0 {
		correct_y = game_size_int
	} else if y > game_size_int {
		correct_y = 0
	} else {
		correct_y = y
	}

	return correct_x, correct_y
}

random_game_space :: proc(game: ^Game) {
	switch game.game_type {
	case GameType.pokemon_auto_battler:
	case GameType.game_of_life:
		gol_random_game(game)
	}
}

main :: proc() {

	curr_game := game_init()
	initialize_window(&curr_game)
	defer rl.CloseWindow()
	gol_random_game(&curr_game)

	for !rl.WindowShouldClose() {
		if check_tick(&curr_game) {
			game_logic(&curr_game)
		}
		game_draw(&curr_game)
	}
}
