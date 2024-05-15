package game_rendering

import cg "../cell_games"
import "core:fmt"
import "core:math"
import rl "vendor:raylib"

WindowInfo :: struct {
	dimensions:           cg.Size,
	min_game_render_size: cg.Size, // is the total amount of pixels it takes to render the game space
	cell_size:            cg.Size, // able to just compute change with window resize
	attached_game:        ^cg.Game,
}

// Used as multiplier for initializing minimal size to render game space
GameSizeMultuplier :: enum {
	fit_game_size = 1,
	small         = 4,
	medium        = 8,
	large         = 16,
}

initialize_window :: proc(game: ^cg.Game, window: ^WindowInfo) {
	game_type_string: cstring

	switch game.game_type {
	case cg.GameType.game_of_life:
		game_type_string := "Game of Life"
	case cg.GameType.pokemon_auto_battler:
		game_type_string := "Pokemon Auto Battler"
	}
	valid_window_size(window)
	rl.InitWindow(i32(window.dimensions.x), i32(window.dimensions.y), game_type_string)
}

valid_window_size :: proc(window: ^WindowInfo) {
	// checking if window dimensions is positive
	if window.dimensions.y < window.min_game_render_size.y {
		window.dimensions.y = window.min_game_render_size.y
	}
	if window.dimensions.x < window.min_game_render_size.x {
		window.dimensions.x = window.min_game_render_size.x
	}

	// checks if smaller than the min
	if window.dimensions.y < window.min_game_render_size.y {
		window.dimensions.y = window.min_game_render_size.y
	}
	if window.dimensions.x < window.min_game_render_size.x {
		window.dimensions.x = window.min_game_render_size.x
	}

	cell_size_ratio_y :=
		f64(window.attached_game.game_size.y) / f64(window.attached_game.game_size.x)
	cell_size_ratio_x :=
		f64(window.attached_game.game_size.x) / f64(window.attached_game.game_size.y)
	window.dimensions.x = cast(int)(f64(window.dimensions.x) * cell_size_ratio_x)
	window.dimensions.y = cast(int)(f64(window.dimensions.y) * cell_size_ratio_y)

}

// encapsulate all actions needed to achieve a window resize
window_resize_handle :: proc(window: ^WindowInfo) {
	// capturing mouse movement and adding it to window dimensions
	if rl.IsMouseButtonDown(rl.MouseButton.LEFT) && mouse_on_border(window) {
		mouse_movement := rl.GetMouseDelta()
		mouse_move_in_size := cg.Size {
			y = cast(int)mouse_movement[1],
			x = cast(int)mouse_movement[0],
		}
		window.dimensions.y += mouse_move_in_size.y
		window.dimensions.x += mouse_move_in_size.x
		valid_window_size(window)

		window.cell_size = cg.Size {
			y = window.dimensions.y / window.attached_game.game_size.y,
			x = window.dimensions.x / window.attached_game.game_size.x,
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
	window_size: cg.Size = cg.Size{800, 800},
	min_multiplier: GameSizeMultuplier = GameSizeMultuplier.medium,
) -> (
	window_info: WindowInfo,
) {
	cell_size := cg.Size {
		y = window_size.y / game.game_size.y,
		x = window_size.x / game.game_size.x,
	}
	window_info = WindowInfo {
		dimensions = window_size,
		min_game_render_size = cg.Size {
			y = game.game_size.y * int(min_multiplier),
			x = game.game_size.x * int(min_multiplier),
		},
		cell_size = cell_size,
		attached_game = game,
	}

	return window_info
}

draw_game_space :: proc(game: ^cg.Game, window: ^WindowInfo) {
	for row in 0 ..< game.game_size.y {
		for column in 0 ..< game.game_size.x {
			curr_pos := (row * game.game_size.y) + column
			curr_cell := &game.game_space[curr_pos]
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
				i32(column * window.cell_size.x),
				i32(row * window.cell_size.y),
				i32(window.cell_size.y),
				i32(window.cell_size.x),
				cell_color,
			)
		}
	}
}

// method to render is game space takes up all the window, gui then is drawn
// on top of the game space.
game_draw :: proc(game: ^cg.Game, window: ^WindowInfo) {
	window_resize_handle(window)
	game_size := game.game_size
	game_space := game.game_space

	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.WHITE)

	draw_game_space(game, window)

}
