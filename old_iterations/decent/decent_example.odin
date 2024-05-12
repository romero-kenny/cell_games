package game_of_life

import "core:fmt"
import "core:math"
import "core:math/rand"
import "core:time"
import rl "vendor:raylib"

game_size :: enum {
	small  = 25,
	medium = 50,
	large  = 100,
	xlarge = 250,
}


game_colors :: struct {
	live_cells:    rl.Color,
	dead_cells:    rl.Color,
	normal_type:   rl.Color,
	fire_type:     rl.Color,
	water_type:    rl.Color,
	electric_type: rl.Color,
	grass_type:    rl.Color,
	ice_type:      rl.Color,
	fighting_type: rl.Color,
	poison_type:   rl.Color,
	ground_type:   rl.Color,
	flying_type:   rl.Color,
	psychic_type:  rl.Color,
	bug_type:      rl.Color,
	rock_type:     rl.Color,
	ghost_type:    rl.Color,
	dragon_type:   rl.Color,
	dark_type:     rl.Color,
	steel_type:    rl.Color,
	fairy_type:    rl.Color,
}

cell_size :: enum {
	small    = 1,
	medium   = 2,
	large    = 4,
	xlarge   = 8,
	xxlarge  = 16,
	xxxlarge = 32,
}

cell :: struct {
	alive: bool,
}

pokemon_type :: enum {
	normal,
	fire,
	water,
	electric,
	grass,
	ice,
	fighting,
	poison,
	ground,
	flying,
	psychic,
	bug,
	rock,
	ghost,
	dragon,
	dark,
	steel,
	fairy,
}

pokemon :: struct {
	type: [2]pokemon_type,
}

game_state_game_of_life :: struct {
	alive_cells: int,
	dead_cells:  int,
}

game_type :: enum {
	game_of_life,
	pokemon_auto_battler,
	none,
}

Game :: struct {
	game_type:       game_type,
	self_play:       bool,
	game_speed:      f64,
	game_size:       game_size,
	colors:          game_colors,
	cell_size:       cell_size,
	game_state:      game_state,
	game:            [dynamic][dynamic]cell,
	game_pokemon:    [dynamic][dynamic]pokemon,
	stopwatch:       time.Stopwatch,
	window_size:     i32,
	prev_game_speed: f64,
	game_paused:     bool,
}

game_state :: union {
	game_state_game_of_life,
}

game_play_game_of_life :: proc(game: ^Game, cell_x, cell_y: int) {
	alive_cells := 0
	for y in -1 ..= 1 {
		for x in -1 ..= 1 {
			if x == 0 && y == 0 {
				continue
			}

			check_y := (y + cell_y) % int(game.game_size)
			check_x := (x + cell_x) % int(game.game_size)
			if check_y < 0 {
				check_y = int(game.game_size) - 1
			}
			if check_x < 0 {
				check_x = int(game.game_size) - 1
			}
			if game.game[check_y][check_x].alive {
				alive_cells += 1
			}
		}
	}

	if alive_cells == 3 {
		game.game[cell_y][cell_x].alive = true
	} else if alive_cells < 2 {
		game.game[cell_y][cell_x].alive = false
	} else if alive_cells > 3 {
		game.game[cell_y][cell_x].alive = false
	}
}

game_play :: proc(game: ^Game) {
	for &row, y in game.game {
		for &indv_cell, x in row {
			switch game.game_type {
			case game_type.game_of_life:
				game_play_game_of_life(game, x, y)
			case game_type.pokemon_auto_battler:
				return
			case game_type.none:
				return
			}

		}
	}
}

game_init :: proc(game: ^Game) {

	// init game are "game"
	game.game = make([dynamic][dynamic]cell)
	resize(&game.game, int(game.game_size))
	assert(len(game.game) == int(game.game_size), "game matrix unable to be made")

	for &row in game.game {
		row = make([dynamic]cell, int(game.game_size))
		assert(len(row) == int(game.game_size), "rows are not being made")
	}

	// self_play / randomize cells; maybe add default play spaces?
	if game.self_play {
		for &row in game.game {
			for &indv_cell in row {
				switch game.game_type {
				case game_type.game_of_life:
					if 0 == rand.int_max(2) {
						indv_cell = cell{true}
					}
				case game_type.pokemon_auto_battler:

				case game_type.none:
					panic("No game type selected")
				}
			}
		}
	}

}

draw_logic_game_of_life :: proc(curr_cell: cell, x, y: int, game: ^Game) {
	if curr_cell.alive {
		rl.DrawRectangle(
			i32(x * int(game.cell_size)),
			i32(y * int(game.cell_size)),
			i32(game.cell_size),
			i32(game.cell_size),
			game.colors.live_cells,
		)
	}
}

draw_game :: proc(game: ^Game) {

	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.ClearBackground(game.colors.dead_cells)


	for &row, y  in game.game {
		for &indv_cell, x in row {
			switch game.game_type {
			case game_type.game_of_life:
				draw_logic_game_of_life(indv_cell, x, y, game)
			case game_type.pokemon_auto_battler:
				return

			case game_type.none:
				return

			}
		}
	}
}

update_game_state_game_of_life :: proc(game: ^Game) {
	alive := 0
	dead := 0

	for &row in game.game {
		for &indv_cell in row {
			if indv_cell.alive {
				alive += 1
			} else {
				dead += 1
			}
		}
	}

	game.game_state = game_state_game_of_life{alive, dead}
}

update_game_state :: proc(game: ^Game) {
	switch game.game_type {
	case game_type.game_of_life:
		update_game_state_game_of_life(game)
	case game_type.pokemon_auto_battler:
		return
	case game_type.none:
		return
	}
}

game_end :: proc(game: ^Game) {
	defer delete(game.game)
	defer {
		for &row in game.game {
			delete(row)
		}
	}
	game.game_type = game_type.none
	update_game_state_game_of_life(game)
}

game_speed :: proc(game: ^Game) -> (run_game: bool) {
	if !game.stopwatch.running {
		time.stopwatch_start(&game.stopwatch)
	} else if time.duration_seconds(time.stopwatch_duration(game.stopwatch)) > game.game_speed {
		run_game = true
		time.stopwatch_reset(&game.stopwatch)
	}

	return run_game
}

within_window_size :: proc(game: ^Game, mouse_x, mouse_y: i32) -> (within: bool) {
	if mouse_x < game.window_size && mouse_y < game.window_size {
		if mouse_x > 0 && mouse_y > 0 {
			within = true
		}
	}

	return within
}

cell_mouse_click :: proc(game: ^Game) {
	mouse := rl.GetMousePosition()
	mouse_x := cast(i32)(mouse[0])
	mouse_y := cast(i32)(mouse[1])

	within_game_window := within_window_size(game, mouse_x, mouse_y)

	if within_game_window {
		cell_coord_x := mouse_x / i32(game.cell_size)
		cell_coord_y := mouse_y / i32(game.cell_size)
		hovered_cell := &game.game[cell_coord_y][cell_coord_x]
		if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
			fmt.println("x: ", cell_coord_x, "y: ", cell_coord_y)
			#partial switch game.game_type {
			case game_type.game_of_life:
				hovered_cell.alive = !hovered_cell.alive
			}
		}
	}
}

pause_game :: proc(game: ^Game) {
	if rl.IsKeyPressed(rl.KeyboardKey.SPACE) {
		if game.game_paused {
			game.game_speed = game.prev_game_speed
			game.game_paused = false
		} else {
			game.prev_game_speed = game.game_speed
			game.game_speed = 999999999999
			game.game_paused = true
		}
	}
}

reset_game :: proc(game: ^Game) {
	using rl
	if IsKeyPressed(KeyboardKey.R) {
		for &row in game.game {
			for &indv_cell in row {
				indv_cell.alive = false
			}
		}
	}
}

player_control :: proc(game: ^Game) {
	cell_mouse_click(game)
	pause_game(game)
	reset_game(game)
}

set_game_colors :: proc(alive_cell_color, dead_cell_color: rl.Color) -> (color_struct: game_colors) {
	return game_colors {
		live_cells = alive_cell_color,
		dead_cells = dead_cell_color,
		normal_type = rl.BEIGE,
		fire_type =  rl.RED,
		water_type = rl.BLUE,
		electric_type = rl.YELLOW,
		grass_type = rl.GREEN,
		ice_type = rl.WHITE,
		fighting_type = rl.DARKGRAY,
		poison_type   = rl.PURPLE,
		ground_type   = rl.BROWN,
		flying_type   = rl.SKYBLUE,
		psychic_type  = rl.DARKPURPLE,
		bug_type      = rl.LIME,
		rock_type     = rl.DARKBROWN,
		ghost_type    = rl.GRAY,
		dragon_type   = rl.ORANGE,
		dark_type     = rl.BLACK,
		steel_type    = rl.LIGHTGRAY,
		fairy_type    = rl.PINK,
	}
}

main :: proc() {
	game := Game {
		game_type  = game_type.game_of_life,
		self_play  = true,
		game_speed = .5,
		game_size  = game_size.medium,
		colors     = set_game_colors(rl.BLACK, rl.YELLOW),
		cell_size  = cell_size.xxlarge,
	}
	game.window_size = i32(int(game.cell_size) * int(game.game_size))

	rl.InitWindow(game.window_size, game.window_size, "Game of Life")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)
	game_init(&game)

	for !rl.WindowShouldClose() {
		player_control(&game)
		if game_speed(&game) {
			game_play(&game)
		}
		draw_game(&game)
	}
}
