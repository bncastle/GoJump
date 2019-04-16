extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "on_player_entered")

func on_player_entered(body):
	get_tree().call_group("pickup_listeners","on_pickup", self)
	queue_free()