extends Node2D
class_name Level

const KEY := 2
const DOOR := 4
const CHAIN := 5
const BLOCK := 6
const LADDER := 7
const COIN := 8
const BLOCK_OUTLINE := 9
const PLAYER := 13
const COMPUTER := 14
const LADDER_TOP := 15

export (PackedScene) var player
export (PackedScene) var coin
export (PackedScene) var key
export (PackedScene) var door
export (PackedScene) var ladder
export (PackedScene) var ladder_top
export (PackedScene) var chain
export (PackedScene) var computer

func _ready():
	call_deferred("setup_tiles")

func setup_tiles():
	var cells = $Tiles.get_used_cells()
	for cell in cells:
		var index = $Tiles.get_cell(cell.x, cell.y)
		match index:
			KEY:
				create_instance_from_tilemap(cell, key, $Items, Vector2(6,6))
			DOOR:
				create_instance_from_tilemap(cell, door, $Triggerables, Vector2(6,6))
			LADDER:
				create_instance_from_tilemap(cell, ladder, $Interactables, Vector2(6,6))
			CHAIN:
				create_instance_from_tilemap(cell, chain, $Interactables, Vector2(6,6))
			COIN:
				create_instance_from_tilemap(cell, coin, $Items, Vector2(6,6))
			PLAYER:
				create_instance_from_tilemap(cell, player, self, Vector2(6,12))
			COMPUTER:
				create_instance_from_tilemap(cell, computer, self, Vector2(6,6))
			LADDER_TOP:
				create_instance_from_tilemap(cell, ladder_top, $Interactables, Vector2(6,6))
			COMPUTER:
				create_instance_from_tilemap(cell, computer, $Triggerables, Vector2(6,6))

func create_instance_from_tilemap(coord:Vector2, prefab:PackedScene, parent: Node2D, offset:Vector2 = Vector2.ZERO):
	$Tiles.set_cell(coord.x, coord.y, -1)
	var pf = prefab.instance()
	pf.position = $Tiles.map_to_world(coord) + offset
	parent.add_child(pf)

#func get_tiles(tile_index:int) -> Array:
#	return $Tiles.get_used_cells_by_id(tile_index)

func replace_tiles(old_tile_index:int, new_tile_index:int):
	var cells = $Tiles.get_used_cells_by_id(old_tile_index)
	for cell in cells:
		$Tiles.set_cell(cell.x, cell.y, new_tile_index)
