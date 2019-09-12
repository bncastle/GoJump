extends "res://Triggerables/BaseTriggerable.gd"

var is_on := false

func _on_triggered():
	_on_player_entered(null)

func _on_player_entered(body):
	if !is_on:
		is_on = true
		$Sprite.frame += 1
		get_tree().call_group("game","computer_on")
