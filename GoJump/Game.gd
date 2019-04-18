extends Node2D

const LVL_PATH = "res://Levels/Level%d.tscn"

var lvl_num:int = 1

func _ready():
	add_to_group("game")
	call_deferred("init")

func init():
	load_level(lvl_num)

func load_level(num:int):
	var root = get_tree().root
	if root.has_node("Level"):
		var lvl = root.get_node("Level")
		root.remove_child(lvl)
		lvl.queue_free()

	#todo:check if level actually exists
	var lvl = load(LVL_PATH % num).instance()
	root.add_child(lvl)
	return true

##Game group functions

func on_next_level():
	lvl_num += 1
	#todo: we want a scen transition of some sort and maybe some "game juice" here
	load_level(lvl_num)
	#todo: something if no more levels

func on_pickup(item):
	if item.name == "Key":
		get_tree().call_group("triggerable","trigger", "Door")