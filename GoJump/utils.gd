extends Node

enum InteractType {NONE, CHAIN, LADDER}

func _ready():
	randomize()

func scale_out(sprite: Sprite, tween: Tween, fade_time:float, should_pause: bool):
	if should_pause:
		get_tree().paused = true
#	tween.interpolate_property(sprite, "modulate:a", f.modulate.a, 1, fade_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	sprite.visible = true
	tween.interpolate_property(sprite, "scale", Vector2.ZERO, Vector2(5,5), fade_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")

func scale_in(sprite: Sprite, tween: Tween, fade_time:float, was_paused: bool):
#	tween.interpolate_property(sprite, "modulate:a", f.modulate.a, 0, fade_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.interpolate_property(sprite, "scale", sprite.scale, Vector2.ZERO, fade_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	sprite.visible = false
	if was_paused:
		get_tree().paused = false


func fade_out(sprite: ColorRect, tween: Tween, fade_time:float, should_pause: bool):
	if should_pause:
		get_tree().paused = true
	sprite.visible = true
	tween.interpolate_property(sprite, "modulate:a", sprite.modulate.a, 1, fade_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")

func fade_in(sprite: ColorRect, tween: Tween, fade_time:float, was_paused: bool):
	tween.interpolate_property(sprite, "modulate:a", sprite.modulate.a, 0, fade_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	sprite.visible = false
	if was_paused:
		get_tree().paused = false
