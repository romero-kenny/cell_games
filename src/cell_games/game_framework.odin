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
	row:    int,
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
	curr_pos:       Position,
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

game_cell_surround_update :: proc(curr_cell: ^Cell, game_space: []Cell, game_size: Size) {
	ind := len(curr_cell.cell_info.neighbor_cells) - 1
	for row in -1 ..= 1 {
		for col in -1 ..= 1 {
			if col == 0 && row == 0 {
				continue
			}
			search_col := curr_cell.cell_info.curr_pos.column + col
			search_row := curr_cell.cell_info.curr_pos.row + row
			search_col, search_row = range_checker(search_col, search_row, game_size)
			search_pos := (search_row * game_size.y) + search_col

			curr_cell.cell_info.neighbor_cells[ind] = &game_space[search_pos].cell_type
			ind -= 1
		}
	}
}

game_logic :: proc(game: ^Game) {
	for &cell in game.game_space {
		game_cell_surround_update(&cell, game.game_space, game.game_size)
		switch game.game_type {
		case GameType.game_of_life:
			gol_cell_rules(&cell.cell_type, cell.cell_info.neighbor_cells[:])
		case GameType.pokemon_auto_battler:
			poke_game_rules(&cell.cell_type, cell.cell_info.neighbor_cells[:])
		}
	}
}

range_checker :: proc(x, y: int, game_size: Size) -> (correct_x, correct_y: int) {
	if x < 0 {
		correct_x = game_size.x - 1
	} else if x >= game_size.x {
		correct_x = 0
	} else {
		correct_x = x
	}

	if y < 0 {
		correct_y = game_size.y - 1
	} else if y >= game_size.y {
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
		gol_random_game(game.game_space, game.game_size)
	}
}

default_game_space :: proc(game: ^Game) {
	switch game.game_type {
	case GameType.pokemon_auto_battler:
	case GameType.game_of_life:
		gol_default_game_space(game.game_space, game.game_size)
	}

}

game_play :: proc(game: ^Game) {
	if check_tick(game) {
		game_logic(game)
	}
}
