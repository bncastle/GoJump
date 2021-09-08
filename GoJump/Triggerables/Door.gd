extends "res://Triggerables/BaseTriggerable.gd"

var is_open := false

func _perform_trigger():
	if !is_open:
		$Anim.play("open")
		is_open = true

func on_player_entered(body):
	if !is_open: return
	print("Change Level")