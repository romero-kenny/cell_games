package cell_games

import "core:math/rand"
import rl "vendor:raylib"

GolCell :: struct {
	alive:     bool,
}

gol_cell_rules :: proc(neighbor_cells: []^CellType) -> (alive: bool) {
	total_alive : int
	for &cell in neighbor_cells {
		gol_cell := &cell.(GolCell)
		if gol_cell.alive {
			total_alive += 1
		}
	}
	if !(total_alive < 2 || total_alive > 3) {
		 alive = true
	}

	return alive
}

gol_random_game :: proc(game_space: []Cell, game_size: int) {
	for y in 0 ..< game_size {
		for x in 0 ..< game_size {
			curr_pos := (y * game_size) + x
			game_space[curr_pos] = Cell {
				cell_type = GolCell {
					alive = rand.int_max(2) != 0
				},
				cell_info = GenericCell {
					curr_pos = [2]int{x, y}
				}
			}
		}
	}
}

gol_default_game_space :: proc(game_space: []Cell, game_size: int) {
	for y in 0 ..< game_size {
		for x in 0 ..< game_size {
			curr_pos := (y * game_size) + x
			game_space[curr_pos] = Cell {
				cell_type = GolCell {
				},
				cell_info = GenericCell {
					curr_pos = [2]int{x, y}
				}
			}
		}
	}
}
