extends Node2D

const LVL_PATH = "res://Levels/Level%d.tscn"
const LVL_PLACEHOLDER = "res://Levels/LevelPlaceholder.tscn"

export(float) var fade_time = 0.5

var lvl_num:int = 1
var lvl_door: Node2D

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
	var lvl = load(LVL_PATH % num)
	if !lvl:
		lvl = load(LVL_PLACEHOLDER)
	self.add_child(lvl.instance())
	return true

func get_level_node():
	if self.has_node("Level"):
		return self.get_node("Level")
	return null

##Game group functions
func on_set_door(new_door):
	lvl_door = new_door

func on_next_level():
	lvl_num += 1
	#The scene transition
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
	if item.type == "Key":
		$GetKey.play()
		get_tree().paused = true
		$Tween.interpolate_property(item, "position", item.position, item.position - Vector2(0, 20), 0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		$Tween.start()
		yield($Tween, "tween_completed")
		#pause briefly
		yield(get_tree().create_timer(0.25), "timeout")

		#make the key goto the door
		$Tween.interpolate_property(item, "position", item.position, lvl_door.position, 0.6, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.interpolate_property(item, "rotation", item.rotation, item.rotation + 2 * TAU, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.interpolate_property(item, "scale", item.scale, Vector2.ONE * 0.1, 0.6, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.start()
		yield($Tween, "tween_all_completed")
		item.queue_free()

		$DoorUnlock.play()
		get_tree().call_group("triggerable", "trigger", "Door")
		get_tree().paused = false
	elif item.type == "Coin":
		$GetCoin.play()


func computer_on():
	var lvl = get_level_node()
	lvl.replace_tiles(Level.BLOCK_OUTLINE, Level.BLOCK)

func computer_off():
	var lvl = get_level_node()
	lvl.replace_tiles(Level.BLOCK, Level.BLOCK_OUTLINE)
