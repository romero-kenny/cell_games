package game_of_life

import "core:fmt"
import "core:math"
import "core:math/rand"
import rl "vendor:raylib"

SMALL :: 25
MEDIUM :: 50
LARGE :: 100
XLARGE :: 250

cell_size :: struct {
	height, width: int,
}

game_space: [XLARGE][XLARGE]bool
cell := cell_size{}

cell_rules :: proc(x, y, size: int) {
	total := 0
	for x_iter in -1 ..= 1 {
		for y_iter in -1 ..= 1 {
			if !(x_iter < 0 && y_iter < 0) {
				if game_space[(math.abs(y - y_iter) % size)][(math.abs(x - x_iter) % size)] {
					total += 1
				}
			}
		}
	}

	if total < 2 {
		game_space[y][x] = false
	} else if total > 3 {
		game_space[y][x] = false
	} else if total == 3 {
		game_space[y][x] = true
	}
}

game_play :: proc(size: int) {
	for &row, y in game_space {
		if y >= size {
			break
		}

		for _, x in row {
			if x >= size {
				break
			}
			cell_rules(x, y, size)
		}
	}
}

game_init :: proc(height, width, size: int) {
	cell = cell_size{width, height}
	for row, y in game_space {
		for &cell, x in game_space {
			if 0 == rand.int_max(2) {
				game_space[x][y] = true
			}
		}
	}
}

game_draw :: proc(size: int) {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.YELLOW)
	for &row, y in game_space {
		if y >= size {
			break
		}
		for &space, x in row {
			if x >= size {
				break
			} else if space {
				rl.DrawRectangle(
					i32(x * cell.width),
					i32(y * cell.height),
					i32(cell.width),
					i32(cell.height),
					rl.PINK,
				)
			}
		}
	}
}

game_creator :: proc(size: int) -> (cellsize: int) {
	switch size {
	case SMALL:
		cellsize = 32
	case MEDIUM:
		cellsize = 16
	case LARGE:
		cellsize = 8
	case XLARGE:
		cellsize = 4
	}

	return cellsize
}

main :: proc() {
	size := SMALL
	cellsize := game_creator(size)
	game_init(cellsize, cellsize, size)

	rl.InitWindow(i32(size * cell.width), i32(size * cell.height), "Game of Life")
	defer rl.CloseWindow()
	rl.SetTargetFPS(30)

	for !rl.WindowShouldClose() {
		game_draw(size)
		game_play(size)
	}
}
