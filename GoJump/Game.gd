extends Node2D

const LVL_PATH = "res://Levels/Level%d.tscn"

var lvl_num:int = 1
onready var Level = preload("res://Levels/Level.gd")

func _ready():
	add_to_group("game")
	call_deferred("init")

func init():
	load_level(lvl_num)

func load_level(num:int):
	var old_lvl = get_level_node()
	var root = get_tree().root
	if old_lvl != null:
		root.remove_child(old_lvl)
		old_lvl.queue_free()

	#todo:check if level actually exists
	var lvl = load(LVL_PATH % num).instance()
	root.add_child(lvl)
	return true

func get_level_node():
	var root = get_tree().root
	if root.has_node("Level"):
		return root.get_node("Level")
	return null

##Game group functions

func on_next_level():
	lvl_num += 1
	#todo: we want a scen transition of some sort and maybe some "game juice" here
	load_level(lvl_num)
	#todo: something if no more levels

func on_pickup(item):
	if item.name == "Key":
		get_tree().call_group("triggerable", "trigger", "Door")

func computer_on():
	var lvl = get_level_node()
	lvl.replace_tiles(Level.BLOCK_OUTLINE, Level.BLOCK)

