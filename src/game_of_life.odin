package cell_games

import rl "vendor:raylib"
import "core:math/rand"

GolCell :: struct {
	alive: bool,
}

gol_cell_surround_check :: proc(cell_x, cell_y: int, game: ^Game) -> (total_alive: int) {
	game_size_int := int(game.game_space_size) 

	for y in -1 ..= 1 {
		for x in -1 ..= 1 {
			if x == 0 && y == 0 {
				continue
			}
			check_x, check_y := range_checker(cell_x + x, cell_y + y, game.game_space_size)
			curr_cell := &game.game_space[(check_y * game_size_int) + check_x].(GolCell)
			if curr_cell.alive {
				total_alive += 1
			}
		}
	}

	return total_alive
}

gol_cell_rules :: proc(alive_cells: int) -> (alive: bool) {
	if alive_cells < 2 || alive_cells > 3 {
		return false
	}

	return true
}

gol_logic_loop :: proc(game: ^Game) {
	game_size := int(game.game_space_size)

	for y in 0 ..< game_size {
		for x in 0 ..< game_size {
			alive_cells := gol_cell_surround_check(x, y, game)
			curr_cell := &game.game_space[(y * game_size) + x].(GolCell)
			if alive_cells != 2 {
				curr_cell.alive = gol_cell_rules(alive_cells)
			}
		}
	}
}

gol_draw_game :: proc(game: ^Game) {
	game_size := int(game.game_space_size)
	for y in 0..< game_size {
		for x in 0..< game_size {
			curr_pos := (y * game_size) + x
			curr_cell := &game.game_space[curr_pos].(GolCell)
			if curr_cell.alive {
				rl.DrawRectangle(
					i32(x * int(game.cell_size)),
					i32(y * int(game.cell_size)),
					i32(game.cell_size),
					i32(game.cell_size),
					rl.PINK,
				)
			}
		}
	}
}

gol_random_game :: proc(game: ^Game) {
	game_size := int(game.game_space_size)
	for y in 0..< game_size {
		for x in 0..< game_size {
			curr_pos := (y * game_size) + x
			alive := bool(rand.int_max(2))
			game.game_space[curr_pos] = GolCell{
				alive = alive,
			}
		}
	}
}
