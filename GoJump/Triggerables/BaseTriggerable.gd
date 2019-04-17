extends Area2D

export (String) var trig_name = ""

func _ready():
	connect("body_entered", self, "on_player_entered")
	add_to_group("triggerable")

func trigger(tag:String):
	if trig_name.length() == 0 || trig_name != tag:
		return
	_perform_trigger()

func _perform_trigger():
	print("Need perform_trigger() implementation for: %s" % filename)

func on_player_entered(body):
	print("Need on_player_entered() implementation for: %s" % filename)