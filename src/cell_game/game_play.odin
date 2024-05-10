package cell_game

import "core:math"
import "core:mem"
import "core:strings"
import "core:time"
import rl "vendor:raylib"

Position :: struct {
	row:    int,
	column: int,
}

Size :: struct {
	y: int,
	x: int,
}


Cell :: struct($CellType: typeid) {
	cell_data: CellType,
	cell_info: CellInfo(CellType),
}

CellInfo :: struct($SpecificCell: typeid) {
	pos:       Position,
	neighbors: [8]^Cell(SpecificCell),
}

GameModuleFunctions :: struct($CellType: typeid) {
	random_game:     proc(_: []Cell(CellType), _: Size),
	default_game:    proc(_: []Cell(CellType), _: Size),
	game_rules:      proc(_: []^Cell(CellType), _: ^Cell(CellType)),
	cell_type_deinit: Maybe(proc(_: ^Cell(CellType))),
}

TimeKeeper :: struct {
	pause:     bool,
	play_rate: f64,
	stopwatch: time.Stopwatch,
}

Game :: struct($SpecificCell: typeid) {
	game_name:      [32]u8,
	game_space:     []Cell(SpecificCell),
	game_size:      Size,
	game_functions: GameModuleFunctions,
	time_keeper:    TimeKeeper,
}


// game loop that applies game rules per cell.
game_space_iterate :: proc(
	game_functions: ^GameModuleFunctions($CellType),
	game_space: []Cell(CellType),
	game_size: Size,
) {
	for row in game_size.y {
		for col in game_size.x {
			flattened_index := (row * game_size.y) + col
			curr_cell := &game_space[flattened_index]
			neighbor_cells := &curr_cell.cell_info.neighbors
			game_functions.game_rules(neighbor_cells, curr_cell)
		}
	}

}

game_init :: proc(
	game_name: string,
	game_type: $CellType,
	game_funcs: GameModuleFunctions(CellType),
	random: bool = true,
	game_size: Size = Size{100, 100},
	allocator: mem.Allocator = context.allocator,
	play_rate: f64 = .1,
) -> (
	new_game: Game(CellType),
) {
	context.allocator = allocator

	time_setup := TimeKeeper {
		pause     = false,
		play_rate = play_rate,
	}

	new_game = Game(type_of(game_type)) {
		game_functions = game_funcs,
		game_size      = game_size,
		time_keeper    = time_setup,
	}

	flattened_game_space := game_size.x * game_size.y
	new_game.game_space = make([]Cell(type_of(game_type), flattened_game_space))

	for char, ind in transmute(u8)game_name {
		if ind >= (len(new_game.game_name) - 2) {
			break
		}
		new_game.game_name[ind] = char
	}

	if random {
		game_funcs.random_game(new_game.game_space, game_size)
	} else {game_funcs.default_game(new_game.game_space, game_size)}

	time.stopwatch_start(&new_game.time_keeper.stopwatch)

	return new_game
}

game_deinit :: proc(game: ^Game) {
	defer delete(game.game_space)

	cell_deinit, ok := game.game_functions.cell_type_deinit.?
	if ok {
		for cell in game.game_space {
			cell_deinit(&cell)
		}
	}
}
