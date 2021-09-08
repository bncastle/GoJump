extends Node2D

const LVL_PATH = "res://Levels/Level%d.tscn"

export(float) var fade_time = 0.5

var lvl_num:int = 1
onready var Level = preload("res://Levels/Level.gd")

func _ready():
	add_to_group("game")
	call_deferred("init")

func init():
	load_level(lvl_num)

func load_level(num:int):
	var old_lvl = get_level_node()
	if old_lvl != null:
		self.remove_child(old_lvl)
		old_lvl.queue_free()

	#todo:check if level actually exists
	var lvl = load(LVL_PATH % num).instance()
	self.add_child(lvl)
	return true

func get_level_node():
	if self.has_node("Level"):
		return self.get_node("Level")
	return null

##Game group functions

func on_next_level():
	lvl_num += 1
	#todo: we want a scene transition of some sort and maybe some "game juice" here
	get_tree().paused = true
	var f = $Container/Fader
	$Tween.interpolate_property(f, "modulate:a", f.modulate.a, 1, fade_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	load_level(lvl_num)
	$Tween.interpolate_property(f, "modulate:a", f.modulate.a, 0, fade_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	get_tree().paused = false

	#todo: something if no more levels

func on_pickup(item):
	if item.name == "Key":
		get_tree().call_group("triggerable", "trigger", "Door")

func computer_on():
	var lvl = get_level_node()
	lvl.replace_tiles(Level.BLOCK_OUTLINE, Level.BLOCK)

