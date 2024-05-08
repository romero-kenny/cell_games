package cell_game

import "core:math"
import "core:time"
import "core:strings"
import rl "vendor:raylib"

Position :: struct {
	row: int,
	column: int,
}

Size :: struct {
	y: int,
	x: int,
}


Cell :: struct($CellType: typeid) {
	cell_type_data: CellType,
	cell_info: CellInfo(CellType),

}

CellInfo :: struct($SpecificCell: typeid) {
	pos: Position,
	neighbors: []^Cell(SpecificCell),
}

GameModuleFunctions :: struct($CellType: typeid){
	random_game: proc([]Cell(CellType), Size),
	default_game: proc([]Cell(CellType), Size),
	game_rules: proc([]^Cell(CellType), ^Cell(SpecificCell))-> typeid,
}

Game :: struct($SpecificCell: typeid) {
	game_type: [20]rune,
	game_space: []Cell(SpecificCell),
	game_size: Size,
	cell_size: Size,
	game_functions: GameModuleFunctions,
}

// game loop that applies game rules per cell.
game_space_iterate :: proc(game_functions: ^GameModuleFunctions($CellType), game_space: []Cell(CellType), game_size: Size) {
}


