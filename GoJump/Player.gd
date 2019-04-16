extends KinematicBody2D

enum { NORMAL, FALL, JUMP, LAND, DIE }

const GRAVITY := 800
const JUMP_VELOCITY := -200
const AIR_JUMP_MULT := 0.75
const MIN_FALL_JUMP = 0.04

onready var velocity := Vector2.ZERO

export var speed := 65
export var air_control := true
export var max_air_jumps := 0

var state := NORMAL
var air_jumps := 0
var jump_start_y := 0.0
var fall_time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	air_jumps = max_air_jumps

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	match state:
		NORMAL:
			if !is_on_floor():
				state = FALL
			else:
				horizontal()
				if Input.is_action_just_pressed("jump"):
					air_jumps = max_air_jumps
					state = JUMP
					jump()
		FALL:
			fall_time += delta
			print(fall_time)
			if fall_time <= MIN_FALL_JUMP:
				state = JUMP
				jump()
			if(is_on_floor()):
				state = LAND
		JUMP:
			jump()
		LAND:
			print("LAND")
			fall_time = 0
			state = NORMAL
		DIE:
			pass

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP, true)

func horizontal():
	if !is_on_floor() and !air_control:
		return

	if Input.is_action_pressed("right"):
		velocity.x = speed
		$Sprite.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -speed
		$Sprite.flip_h = true
	else:
		velocity.x = 0

	if is_on_floor():
		if velocity.x == 0:
			$Anim.play("idle")
		else:
			$Anim.play("walk")

func jump():
	horizontal()
	if Input.is_action_just_pressed("jump") and (air_jumps >= 0):
		$Anim.play("jump")
		if air_jumps == max_air_jumps && is_on_floor():
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY * AIR_JUMP_MULT

		jump_start_y = global_position.y
		air_jumps -= 1
	elif is_on_floor() and velocity.y > 0:
		state = LAND
	elif global_position.y > jump_start_y:
		fall_time = 0
		state = FALL
