extends Area2D

func _ready():
	connect("body_entered", self, "on_player_entered")

func on_player_entered(body):
	get_tree().call_group("pickup_listeners","on_pickup", self)
	queue_free()