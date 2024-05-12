package cell_games

import "core:math"
import "core:time"
import rl "vendor:raylib"

GameType :: enum {
	game_of_life,
	pokemon_auto_battler,
}

CellType :: union {
	GolCell,
	PokeCell,
}

Size :: struct {
	y: int,
	x: int,
}

Position :: struct {
	row: int,
	column: int,
}

TickKeeper :: struct {
	pause:          bool,
	curr_tick_rate: f64, // measured in seconds
	stopwatch:      time.Stopwatch,
}

Game :: struct {
	game_type:  GameType,
	game_space: []Cell,
	game_size:  Size,
	tick_rate:  TickKeeper,
}


Cell :: struct {
	cell_type: CellType,
	cell_info: CellInfo,
}

CellInfo :: struct {
	neighbor_cells: [8]^CellType,
	curr_pos:	Position,
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
	window_size 
	game_type_string: cstring

	switch game.game_type {
	case GameType.game_of_life:
		game_type_string = "Game of Life"
	case GameType.pokemon_auto_battler:
		game_type_string = "Pokemon Auto Battler"
	}

	rl.InitWindow(window_size, window_size, game_type_string)
}

// tick_rate is in seconds
game_init :: proc(
	game_type: GameType = GameType.game_of_life,
	game_size: Size = Size{20, 20},
	tick_rate: f64 = .5,
) -> (
	game: Game,
) {
	// flatten gamespace to better use memory. 
	flattened_size := game_size.y * game_size.x
	game_space := make([]Cell, flattened_size)
	tick_keeper := TickKeeper {
		curr_tick_rate = tick_rate,
	}

	game = Game {
		game_type  = game_type,
		game_space = game_space,
		game_size  = game_size,
		tick_rate  = tick_keeper,
	}
	time.stopwatch_start(&game.tick_rate.stopwatch)

	return game
}

game_cell_surround_update :: proc(curr_cell: ^Cell, game_space: []Cell, game_size: int) {
	ind := len(curr_cell.cell_info.neighbor_cells) - 1
	for y in -1 ..= 1 {
		for x in -1 ..= 1 {
			if x == 0 && y == 0 {
				continue
			}
			search_x := curr_cell.cell_info.curr_pos[0] + x
			search_y := curr_cell.cell_info.curr_pos[1] + y
			search_x, search_y = range_checker(search_x, search_y, game_size)
			search_pos := (search_y * game_size) + search_x

			curr_cell.cell_info.neighbor_cells[ind] = &game_space[search_pos].cell_type
			ind -= 1
		}
	}
}

game_logic :: proc(game: ^Game) {
	game_size := int(game.game_space_size)

	for &cell in game.game_space {
		game_cell_surround_update(&cell, game.game_space, game_size)
		switch game.game_type {
		case GameType.game_of_life:
			curr_cell := &cell.cell_type.(GolCell)
			curr_cell.alive = gol_cell_rules(cell.cell_info.neighbor_cells[:])
		case GameType.pokemon_auto_battler:
			curr_cell := &cell.cell_type.(PokeCell)
			curr_cell.primary_type = poke_game_rules(curr_cell, cell.cell_info.neighbor_cells[:])
		}
	}
}

game_draw :: proc(game: ^Game) {
	game_size := int(game.game_space_size)
	game_space := game.game_space
	cell_size := int(game.cell_size)

	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.WHITE)

	for y in 0 ..< game_size {
		for x in 0 ..< game_size {
			curr_pos := (y * game_size) + x
			curr_cell := &game_space[curr_pos]
			cell_color: rl.Color
			switch &cell in curr_cell.cell_type {
			case GolCell:
				if cell.alive {
					cell_color = rl.PINK
				} else {
					cell_color = rl.WHITE
				}
			case PokeCell:
				cell_color = PokeColors[cell.primary_type]
			}
			rl.DrawRectangle(
				i32(x * cell_size),
				i32(y * cell_size),
				i32(cell_size),
				i32(cell_size),
				cell_color,
			)
		}
	}
}

range_checker :: proc(x, y, game_size: int) -> (correct_x, correct_y: int) {
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
		poke_random_game(game.game_space, game.game_size)
	case GameType.game_of_life:
		gol_random_game(game.game_space, int(game.game_space_size))
	}
}

default_game_space :: proc(game: ^Game) {
	switch game.game_type {
	case GameType.pokemon_auto_battler:
	case GameType.game_of_life:
		gol_default_game_space(game.game_space, int(game.game_space_size))
	}

}

main :: proc() {

	curr_game := game_init(game_type = GameType.pokemon_auto_battler)
	initialize_window(&curr_game)
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		if check_tick(&curr_game) {
			game_logic(&curr_game)
		}
		game_draw(&curr_game)
	}
}
