package game_rendering

import cg "../cell_games"
import "core:fmt"
import "core:math"
import rl "vendor:raylib"

WindowInfo :: struct {
	dimensions:       cg.Size,
	game_render_size: cg.Size, // is the total amount of pixels it takes to render the game space
}

// inits window and sets min window size
initialize_window :: proc(game: ^cg.Game) {
	window_size := i32(game.game_size.y * 16)
	game_type_string: cstring

	switch game.game_type {
	case cg.GameType.game_of_life:
		game_type_string := "Game of Life"
	case cg.GameType.pokemon_auto_battler:
		game_type_string := "Pokemon Auto Battler"
	}

	rl.InitWindow(window_size, window_size, game_type_string)
	rl.SetWindowMinSize(window_size, window_size)
}

// encapsulate all actions needed to achieve a window resize
window_resize_handle :: proc(window: ^WindowInfo) {
	// capturing mouse movement and adding it to window dimensions
	if rl.IsMouseButtonDown(rl.MouseButton.LEFT) && mouse_on_border(window) {
		mouse_movement := rl.GetMouseDelta()
		mouse_move_in_size := cg.Size {
			y = auto_cast mouse_movement[1],
			x = auto_cast mouse_movement[0],
		}
		window.dimensions.y += mouse_move_in_size.y
		window.dimensions.x += mouse_move_in_size.x
		if window.dimensions.y < window.game_render_size.y {
			window.dimensions.y = window.game_render_size.y
		}
		if window.dimensions.x < window.game_render_size.x {
			window.dimensions.x = window.game_render_size.x
			fmt.println(window)
		}
		rl.SetWindowSize(i32(window.dimensions.x), i32(window.dimensions.y))
	}
}

mouse_on_border :: proc(window: ^WindowInfo) -> (is_on_border: bool) {
	mouse_position := rl.GetMousePosition()
	mouse_pos_int := cg.Size {
		y = cast(int)mouse_position[1],
		x = cast(int)mouse_position[0],
	}
	if mouse_pos_int.y < window.dimensions.y - 5 ||
	   mouse_pos_int.y < 5 ||
	   mouse_pos_int.x < 5 ||
	   mouse_pos_int.x < window.dimensions.x - 5 {
		is_on_border = true
	}

	return is_on_border
}

init_window_info :: proc(
	game: ^cg.Game,
	window_size: cg.Size = cg.Size{600, 480},
) -> (
	window_info: WindowInfo,
) {
	window_info = WindowInfo {
		dimensions = window_size,
		game_render_size = cg.Size {
			y = (window_size.y / game.game_size.y) * game.game_size.y,
			x = (window_size.x / game.game_size.x) * game.game_size.x,
		},
	}

	if window_info.game_render_size.y < 1 {
		window_info.game_render_size.y = 1 * game.game_size.y
	}
	if window_info.game_render_size.x < 1 {
		window_info.game_render_size.x = 1 * game.game_size.x
	}
	return window_info
}

game_draw :: proc(game: ^cg.Game, window: ^WindowInfo) {
	game_size := game.game_size
	game_space := game.game_space
	cell_size := cg.Size {
		y = window.dimensions.y / game.game_size.y,
		x = window.dimensions.x / game.game_size.x,
	}
	window_resize_handle(window)

	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.WHITE)

	for row in 0 ..< game_size.y {
		for column in 0 ..< game_size.x {
			curr_pos := (row * game.game_size.y) + column
			curr_cell := &game_space[curr_pos]
			cell_color: rl.Color
			switch &cell in curr_cell.cell_type {
			case cg.GolCell:
				if cell.alive {
					cell_color = rl.PINK
				} else {
					cell_color = rl.WHITE
				}
			case cg.PokeCell:
				cell_color = cg.PokeColors[cell.primary_type]
			}
			rl.DrawRectangle(
				i32(row * cell_size.y),
				i32(column * cell_size.x),
				i32(cell_size.y),
				i32(cell_size.x),
				cell_color,
			)
		}
	}
}
