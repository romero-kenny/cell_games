package example_games

import cg "../cell_game"
import "core:math/rand"
import rl "vendor:raylib"

GolCell :: struct {
	alive: bool,
}

gol_cell_rules :: proc(
	neighbor_cells: []^Cell(GolCell),
	_: ^Cell(GolCell) = Cell(GolCell){},
) -> (
	alive: bool,
) {
	total_alive: int
	for &cell in neighbor_cells {
		gol_cell := &cell.cell_type_data
		if gol_cell.alive {
			total_alive += 1
		}
	}
	if !(total_alive < 2 || total_alive > 3) {
		alive = true
	}

	return alive
}

gol_random_game :: proc(game_space: []Cell(GolCell), game_size: cg.Size) {
	for row in 0 ..< game_size.y {
		for column in 0 ..< game_size.x {
			curr_pos := (row * (game_size.x * game_size.y)) + column
			game_space[curr_pos] = Cell {
				cell_type = GolCell{alive = rand.choice([]bool{true, false})},
				cell_info = cg.CellInfo{pos = cg.Position{row, column}},
			}
		}
	}
}

gol_default_game_space :: proc(game_space: []Cell(GolCell), game_size: cg.Size) {
	for row in 0 ..< game_size.y {
		for column in 0 ..< game_size.x {
			curr_pos := (row * (game_size.x * game_size.y)) + column
			game_space[curr_pos] = Cell {
				cell_type = GolCell{},
				cell_info = cg.CellInfo{
					pos = cg.Position{row, column},
				}
			}
		}
	}
}
