package cell_games

import rl "vendor:raylib"

PokeTypes :: enum {
	none,
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
	dragon,
	dark,
	steel,
	fairy,
}

PokeColors :: struct {
	none:     rl.Color,
	normal:   rl.Color,
	fire:     rl.Color,
	water:    rl.Color,
	electric: rl.Color,
	grass:    rl.Color,
	ice:      rl.Color,
	fighting: rl.Color,
	poison:   rl.Color,
	ground:   rl.Color,
	flying:   rl.Color,
	psychic:  rl.Color,
	bug:      rl.Color,
	rock:     rl.Color,
	dragon:   rl.Color,
	dark:     rl.Color,
	steel:    rl.Color,
	fairy:    rl.Color,
}

PokeCell :: struct {
	primary_type: PokeTypes,
}

poke_color_chooser :: proc(poke_type: PokeTypes) -> rl.Color {
	using PokeTypes

	switch poke_type {
	case none:
		return rl.VIOLET
	case normal:
		return rl.BEIGE
	case fire:
		return rl.RED
	case water:
		return rl.BLUE
	case electric:
		return rl.YELLOW
	case grass:
		return rl.GREEN
	case ice:
		return rl.LIGHTGRAY
	case fighting:
		return rl.BROWN
	case poison:
		return rl.PURPLE
	case ground:
		return rl.DARKBROWN
	case flying:
		return rl.SKYBLUE
	case psychic:
		return rl.DARKPURPLE
	case bug:
		return rl.LIME
	case rock:
		return rl.GRAY
	case dragon:
		return rl.ORANGE
	case dark:
		return rl.BLACK
	case steel:
		return rl.WHITE
	case fairy:
		return rl.PINK
	case ghost:
		return rl.DARKGRAY
	}

	return rl.Color{0, 0, 0, 0}
}

poke_type_effectiveness :: proc(
	curr_pokemon_type, surround_pokemon_type: PokeTypes,
) -> (
	multiplier: f64,
) {
	switch curr_pokemon_type {
	case none:
		switch surround_pokemon_type {
		case none:
			multiplier = 4
		case normal:
			multiplier = 1
		case fire:
			multiplier = 1
		case water:
			multiplier = 1
		case electric:
			multiplier = 1
		case grass:
			multiplier = 1
		case ice:
			multiplier = 1
		case fighting:
			multiplier = 2
		case poison:
			multiplier = 2
			
		case ground:
			multiplier = 2
			
		case flying:
			multiplier = 2
			
		case psychic:
			multiplier = 2
			
		case bug:
			multiplier = 2
			
		case rock:
			multiplier = 2
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case normal:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case fire:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case water:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case electric:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case grass:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case ice:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case fighting:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case poison:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case ground:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case flying:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case psychic:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case bug:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case rock:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case dragon:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case dark:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case steel:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	case fairy:
		switch surround_pokemon_type {
		case none:
			
		case normal:
			
		case fire:
			
		case water:
			
		case electric:
			
		case grass:
			
		case ice:
			
		case fighting:
			
		case poison:
			
		case ground:
			
		case flying:
			
		case psychic:
			
		case bug:
			
		case rock:
			
		case dragon:
			
		case dark:
			
		case steel:
			
		case fairy:
			
		}
		
	}
	return multiplier
}

poke_fight :: proc(curr_pokemon, surrounding_pokemon: ^PokeCell) {
	using PokeTypes

	// god forgive me for what i'm about to do
	switch curr_pokemon {
	}

}

poke_fight_chooser :: proc(curr_x, curr_y: int, curr_pokemon: ^PokeCell, game: ^Game) {
	game_size := int(game.game_space_size)

	for y in -1 ..= 1 {
		for x in -1 ..= 1 {

		}
	}
}

poke_play_game :: proc(game: ^Game) {
	game_size := int(game.game_space_size)

	for y in 0 ..< game_size {
		for x in 0 ..< game_size {
			curr_pos := (y * game_size) + x
			curr_pokemon := &game.game_space[curr_pos].(PokeCell)
		}
	}
}

poke_draw_game :: proc(game: ^Game) {
	game_size := int(game.game_space_size)

	for y in 0 ..< game_size {
		for x in 0 ..< game_size {
			curr_pos := (y * game_size) + x
			curr_pokemon := &game.game_space[curr_pos].(PokeCell)

			rl.DrawRectangle(
				i32(x * int(game.cell_size)),
				i32(y * int(game.cell_size)),
				i32(game.cell_size),
				i32(game.cell_size),
				poke_color_chooser(curr_pokemon.primary_type),
			)
		}
	}
}
