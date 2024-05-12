package cell_games

import "core:math/rand"
import rl "vendor:raylib"

// index for types are mapped based on auto-assigned enum number from PokeTypes
@(private = "file")
EffectivenessChart := make(map[PokeTypes][PokeTypes]f64)

PokeColors := [PokeTypes]rl.Color{
		.none = rl.BLACK,
		.normal = rl.BEIGE,
		.fire = rl.RED,
		.water = rl.BLUE,
		.electric = rl.YELLOW,
		.grass = rl.GREEN,
		.ice = rl.WHITE,
		.fighting = rl.DARKBROWN,
		.poison = rl.DARKPURPLE,
		.ground = rl.BROWN,
		.flying = rl.SKYBLUE,
		.psychic = rl.PURPLE,
		.bug = rl.LIME,
		.rock = rl.LIGHTGRAY,
		.ghost = rl.DARKBLUE,
		.dragon = rl.ORANGE,
		.dark = rl.GRAY,
		.steel = rl.LIGHTGRAY,
		.fairy = rl.PINK,
}

PokeCell :: struct {
	primary_type: PokeTypes,
}

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
	ghost,
	dragon,
	dark,
	steel,
	fairy,
}


PokeFightOutcomes :: enum {
	lost = 0,
	draw = 1,
	win  = 2,
}

// Lord, forgive me....
poke_setup_effectiveness_array :: proc(poke_type: PokeTypes) -> (ret_array: [PokeTypes]f64){
	using PokeTypes
	switch poke_type {
	case none:
		ret_array = [PokeTypes]f64 {
			none     = 0,
			normal   = 0,
			fire     = 0,
			water    = 0,
			electric = 0,
			grass    = 0,
			ice      = 0,
			fighting = 0,
			poison   = 0,
			ground   = 0,
			flying   = 0,
			psychic  = 0,
			bug      = 0,
			rock     = 0,
			ghost    = 0,
			dragon   = 0,
			dark     = 0,
			steel    = 0,
			fairy    = 0,
		}
	case normal:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 1,
			fire     = 1,
			water    = 1,
			electric = 1,
			grass    = 1,
			ice      = 1,
			fighting = 1,
			poison   = 1,
			ground   = 1,
			flying   = 1,
			psychic  = 1,
			bug      = 1,
			rock     = .5,
			ghost    = 0,
			dragon   = 1,
			dark     = 1,
			steel    = .5,
			fairy    = 1,
		}
	case fire:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 1,
			fire     = .5,
			water    = .5,
			electric = 1,
			grass    = 2,
			ice      = 2,
			fighting = 1,
			poison   = 1,
			ground   = 1,
			flying   = 1,
			psychic  = 1,
			bug      = 2,
			rock     = .5,
			ghost    = 1,
			dragon   = .5,
			dark     = 1,
			steel    = 2,
			fairy    = 1,
		}
	case water:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 1,
			fire     = 2,
			water    = .5,
			electric = 1,
			grass    = .5,
			ice      = 1,
			fighting = 1,
			poison   = 1,
			ground   = 2,
			flying   = 1,
			psychic  = 1,
			bug      = 1,
			rock     = 2,
			ghost    = 1,
			dragon   = .5,
			dark     = 1,
			steel    = 1,
			fairy    = 1,
		}
	case electric:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 1,
			fire     = 1,
			water    = 2,
			electric = .5,
			grass    = .5,
			ice      = 1,
			fighting = 1,
			poison   = 1,
			ground   = 0,
			flying   = 2,
			psychic  = 1,
			bug      = 1,
			rock     = 1,
			ghost    = 1,
			dragon   = .5,
			dark     = 1,
			steel    = 1,
			fairy    = 1,
		}
	case grass:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 1,
			fire     = .5,
			water    = 2,
			electric = 1,
			grass    = .5,
			ice      = 1,
			fighting = 1,
			poison   = .5,
			ground   = 2,
			flying   = .5,
			psychic  = 1,
			bug      = .5,
			rock     = 2,
			ghost    = 1,
			dragon   = .5,
			dark     = 1,
			steel    = .5,
			fairy    = 1,
		}
	case ice:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 1,
			fire     = .5,
			water    = .5,
			electric = 1,
			grass    = 2,
			ice      = .5,
			fighting = 1,
			poison   = 1,
			ground   = 2,
			flying   = 2,
			psychic  = 1,
			bug      = 1,
			rock     = 1,
			ghost    = 1,
			dragon   = 2,
			dark     = 1,
			steel    = .5,
			fairy    = 1,
		}
	case fighting:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 2,
			fire     = 1,
			water    = 1,
			electric = 1,
			grass    = 1,
			ice      = 2,
			fighting = 1,
			poison   = .5,
			ground   = 1,
			flying   = .5,
			psychic  = .5,
			bug      = .5,
			rock     = 2,
			ghost    = 0,
			dragon   = 1,
			dark     = 2,
			steel    = 2,
			fairy    = .5,
		}
	case poison:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 1,
			fire     = 1,
			water    = 1,
			electric = 1,
			grass    = 2,
			ice      = 1,
			fighting = 1,
			poison   = .5,
			ground   = .5,
			flying   = 1,
			psychic  = 1,
			bug      = 1,
			rock     = .5,
			ghost    = .5,
			dragon   = 1,
			dark     = 1,
			steel    = 0,
			fairy    = 2,
		}
	case ground:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 1,
			fire     = 2,
			water    = 1,
			electric = 2,
			grass    = .5,
			ice      = 1,
			fighting = 1,
			poison   = 2,
			ground   = 1,
			flying   = 0,
			psychic  = 1,
			bug      = .5,
			rock     = 2,
			ghost    = 1,
			dragon   = 1,
			dark     = 1,
			steel    = 2,
			fairy    = 1,
		}
	case flying:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 1,
			fire     = 1,
			water    = 1,
			electric = .5,
			grass    = 2,
			ice      = 1,
			fighting = 2,
			poison   = 1,
			ground   = 1,
			flying   = 1,
			psychic  = 1,
			bug      = 2,
			rock     = .5,
			ghost    = 1,
			dragon   = 1,
			dark     = 1,
			steel    = .5,
			fairy    = 1,
		}
	case psychic:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 1,
			fire     = 1,
			water    = 1,
			electric = 1,
			grass    = 1,
			ice      = 1,
			fighting = 2,
			poison   = 2,
			ground   = 1,
			flying   = 1,
			psychic  = .5,
			bug      = 1,
			rock     = 1,
			ghost    = 1,
			dragon   = 1,
			dark     = 0,
			steel    = .5,
			fairy    = 1,
		}
	case bug:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 1,
			fire     = .5,
			water    = 1,
			electric = 1,
			grass    = 2,
			ice      = 1,
			fighting = .5,
			poison   = .5,
			ground   = 1,
			flying   = .5,
			psychic  = 2,
			bug      = 1,
			rock     = 1,
			ghost    = .5,
			dragon   = 1,
			dark     = 2,
			steel    = .5,
			fairy    = .5,
		}
	case rock:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 1,
			fire     = 2,
			water    = 1,
			electric = 1,
			grass    = 1,
			ice      = 2,
			fighting = .5,
			poison   = 1,
			ground   = .5,
			flying   = 2,
			psychic  = 1,
			bug      = 2,
			rock     = 1,
			ghost    = 1,
			dragon   = 1,
			dark     = 1,
			steel    = .5,
			fairy    = 1,
		}
	case ghost:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 0,
			fire     = 1,
			water    = 1,
			electric = 1,
			grass    = 1,
			ice      = 1,
			fighting = 1,
			poison   = 1,
			ground   = 1,
			flying   = 1,
			psychic  = 2,
			bug      = 1,
			rock     = 1,
			ghost    = 2,
			dragon   = 1,
			dark     = .5,
			steel    = 1,
			fairy    = 1,
		}
	case dragon:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 1,
			fire     = 1,
			water    = 1,
			electric = 1,
			grass    = 1,
			ice      = 1,
			fighting = 1,
			poison   = 1,
			ground   = 1,
			flying   = 1,
			psychic  = 1,
			bug      = 1,
			rock     = 1,
			ghost    = 1,
			dragon   = 2,
			dark     = 1,
			steel    = .5,
			fairy    = 0,
		}
	case dark:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 1,
			fire     = 1,
			water    = 1,
			electric = 1,
			grass    = 1,
			ice      = 1,
			fighting = 1,
			poison   = .5,
			ground   = 1,
			flying   = 1,
			psychic  = 2,
			bug      = 1,
			rock     = 1,
			ghost    = 2,
			dragon   = 1,
			dark     = .5,
			steel    = 1,
			fairy    = .5,
		}
	case steel:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 1,
			fire     = .5,
			water    = .5,
			electric = .5,
			grass    = 1,
			ice      = 2,
			fighting = 1,
			poison   = 1,
			ground   = 1,
			flying   = 1,
			psychic  = 1,
			bug      = 1,
			rock     = 2,
			ghost    = 1,
			dragon   = 1,
			dark     = 1,
			steel    = .5,
			fairy    = 2,
		}
	case fairy:
		ret_array = [PokeTypes]f64 {
			none     = 1,
			normal   = 1,
			fire     = .5,
			water    = 1,
			electric = 1,
			grass    = 1,
			ice      = 1,
			fighting = 1,
			poison   = 2,
			ground   = .5,
			flying   = 1,
			psychic  = 1,
			bug      = 1,
			rock     = 1,
			ghost    = 1,
			dragon   = 2,
			dark     = 2,
			steel    = .5,
			fairy    = 1,
		}
	}

	return ret_array
}

poke_setup_effectiveness_chart :: proc() {
	for poke_type in PokeTypes {
		EffectivenessChart[poke_type] = poke_setup_effectiveness_array(poke_type)
	}
}

poke_fight :: proc(attacker, defender: PokeTypes) -> (attacker_win: PokeFightOutcomes) {
	attack_stat := EffectivenessChart[attacker][defender]
	if attack_stat > 1 {
		attacker_win = PokeFightOutcomes.win
	} else if attack_stat == 1 {
		attacker_win = PokeFightOutcomes.draw
	} else {
		attacker_win = PokeFightOutcomes.lost
	}

	return attacker_win
}

poke_game_rules :: proc(curr_pokemon: ^PokeCell, neighbors: []^CellType) {
	for &pokemon in neighbors {
		defender_pokemon := &pokemon.(PokeCell)
		curr_fight_outcome := poke_fight(curr_pokemon.primary_type, defender_pokemon.primary_type)

		switch curr_fight_outcome {
		case .lost:
		case .draw:
		case .win:
			defender_pokemon.primary_type = curr_pokemon.primary_type
		}
	}
}

poke_random_game :: proc(game_space: []Cell, game_size: Size) {
	poke_setup_effectiveness_chart()
	for y in 0 ..< game_size.y {
		for x in 0 ..< game_size.x {
			curr_pos := (y * game_size.y) + x
			game_space[curr_pos] = Cell {
				cell_type = PokeCell{primary_type = rand.choice_enum(PokeTypes)},
				cell_info = GenericCell{curr_pos = [2]int{x, y}},
			}
		}
	}
}
