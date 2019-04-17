extends Node2D

const KEY := 2
const DOOR := 4
const COIN := 8
const PLAYER := 13

export (PackedScene) var player
export (PackedScene) var coin
export (PackedScene) var key
export (PackedScene) var door

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
			COIN:
				create_instance_from_tilemap(cell, coin, $Items, Vector2(6,6))
			PLAYER:
				create_instance_from_tilemap(cell, player, self, Vector2(6,12))


func create_instance_from_tilemap(coord:Vector2, prefab:PackedScene, parent: Node2D, offset:Vector2 = Vector2.ZERO):
	$Tiles.set_cell(coord.x, coord.y, -1)
	var pf = prefab.instance()
	pf.position = $Tiles.map_to_world(coord) + offset
	parent.add_child(pf)

