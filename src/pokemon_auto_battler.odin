package cell_games

import rl "vendor:raylib"

// index for types are mapped based on auto-assigned enum number from PokeTypes
@(private="file")
EffectivenessChart := make(map[PokeTypes][]f64, len(PokeTypes))

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

poke_setup_effectiveness_struct :: proc(poke_type: PokeTypes) -> []f64{
	using PokeTypes
	effect_array := make([]f64, len(PokeTypes))
	switch poke_type {
	case none:
		multipliers := [len(PokeTypes)]f64{}
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

	return effect_array
}

poke_setup_effectiveness_chart :: proc() {
	for poke_type in PokeTypes {
	}
}

PokeCell :: struct {
	primary_type: PokeTypes,
}

