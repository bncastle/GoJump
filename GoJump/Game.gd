extends Node2D

const LVL_PATH = "res://Levels/Level%d.tscn"

var lvl_num:int = 1

func _ready():
	add_to_group("pickup_listeners")
	call_deferred("init")

func init():
	load_level(lvl_num)

func load_level(num:int):
	var root = get_tree().root
	if root.has_node("Level"):
		root.remove_child($Level)

	#todo:check if level actually exists
	var lvl = load(LVL_PATH % num).instance()
	root.add_child(lvl)
	return true

func on_pickup(item):
	print(item.name)