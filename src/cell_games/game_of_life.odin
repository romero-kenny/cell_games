package cell_games

import "core:math/rand"
import rl "vendor:raylib"

GolCell :: struct {
	alive:     bool,
}

gol_cell_rules :: proc(curr_cell: ^CellType, neighbor_cells: []^CellType) {
	total_alive : int
	for &cell in neighbor_cells {
		gol_cell := &cell.(GolCell)
		if gol_cell.alive {
			total_alive += 1
		}
	}
	gol_cell := &curr_cell.(GolCell)
	if !(total_alive < 2 || total_alive > 3) {
		gol_cell.alive = true
	} else {gol_cell.alive = false}

}

gol_random_game :: proc(game_space: []Cell, game_size: Size) {
	for row in 0 ..< game_size.y {
		for column in 0 ..< game_size.x {
			curr_pos := (row * game_size.y) + column
			game_space[curr_pos] = Cell {
				cell_type = GolCell {
					alive = rand.choice([]bool{true, false})
				},
				cell_info = CellInfo {
					curr_pos = Position{row = row, column = column}
				}
			}
		}
	}
}

gol_default_game_space :: proc(game_space: []Cell, game_size: Size) {
	for row in 0 ..< game_size.y {
		for column in 0 ..< game_size.x {
			curr_pos := (row * game_size.y) + column
			game_space[curr_pos] = Cell {
				cell_type = GolCell {},
				cell_info = CellInfo {
					curr_pos = Position{row = row, column = column}
				}
			}
		}
	}
}
