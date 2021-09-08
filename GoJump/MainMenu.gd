extends Control

func _ready():
	yield(utils.fade_in($Fader, $Tween, 1, true), "completed")

func _on_Start_Button_pressed():
	yield(utils.fade_out($Fader, $Tween, 0.5, true), "completed")
	get_tree().change_scene("res://Game.tscn")


func _on_Quit_Button2_pressed():
	yield(utils.fade_out($Fader, $Tween, 0.5, true), "completed")
	get_tree().quit()
