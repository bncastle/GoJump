extends Area2D

export (String) var tag

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("triggerable")
	connect("body_entered", self, "_on_player_entered")

func trigger(tag_name:String):
	if tag.length() == 0 || tag != tag_name:
		return
	_on_triggered()

func _on_triggered():
	print("Need implementation of _on_triggered() in file: %s" % filename)

func _on_player_entered(body):
	print("Need implementation of _on_player_entered() in file: %s" % filename)
