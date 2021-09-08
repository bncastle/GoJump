extends Area2D

export(bool) var anim_random_start = false

func _ready():
	connect("body_entered", self, "on_player_entered")

	if anim_random_start:
		var anim_offset = $Anim.current_animation_length * randf()
		$Anim.advance(anim_offset)

func on_player_entered(body):
	get_tree().call_group("game","on_pickup", self)
	queue_free()
