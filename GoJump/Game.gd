extends Node2D

const LVL_PATH = "res://Levels/Level%d.tscn"

export(float) var fade_time = 0.5

var lvl_num:int = 1
var lvl_door: Node2D
var viewport_size
onready var Level = preload("res://Levels/Level.gd")

func _ready():
	add_to_group("game")
	viewport_size = get_viewport_rect().size
	call_deferred("init")

func init():
	load_level(lvl_num)

func load_level(num:int):
	var old_lvl = get_level_node()
	if old_lvl != null:
		self.remove_child(old_lvl)
		old_lvl.queue_free()

	#todo:check if level actually exists
	var lvl_scn = load(LVL_PATH % num)
	if lvl_scn != null:
		var lvl = lvl_scn.instance()
		lvl.name = "Level"
		self.add_child(lvl)
		return true
	else:
		print("%s does not exist! TODO: Win Game!" % [LVL_PATH % num])
		return false

func get_level_node():
	if self.has_node("Level"):
		return self.get_node("Level")
	return null

##Game group functions
func on_set_door(new_door):
	lvl_door = new_door

func on_next_level():
	lvl_num += 1
	$Circle.position = lvl_door.position
	yield(utils.scale_out($Circle, $Tween, fade_time, true), "completed")
	#yield(utils.fade_out($Container/Fader, $Tween, fade_time, true), "completed")
	load_level(lvl_num)
	#todo: check return value of load_level to determine if there are in fact any more levels left
	yield(get_tree().create_timer(0.25), "timeout")
	$Circle.position = viewport_size / 2
#	yield(utils.fade_in($Container/Fader, $Tween, fade_time, true), "completed")
	yield(utils.scale_in($Circle, $Tween, fade_time, true), "completed")

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
		
		$Level/Player.set_eyes(Color.orangered, 2)
		
	elif item.type == "Coin":
		$GetCoin.play()


func computer_on():
	var lvl = get_level_node()
	lvl.replace_tiles(Level.BLOCK_OUTLINE, Level.BLOCK)

