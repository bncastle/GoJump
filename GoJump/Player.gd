extends KinematicBody2D

enum { NORMAL, JUMP, FALL, LAND, DIE }
const GRAVITY := 800
const JUMP_VELOCITY := -200
const AIR_JUMP_MULT := 0.75
const MIN_FALL_JUMP_TIME := 0.05

onready var velocity := Vector2.ZERO

export var speed := 65
export var air_control := true
export var max_air_jumps := 1

var state := NORMAL
var air_jumps := 0
var last_y := 0.0
var fall_time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	#Allows the 1st call to is_on_floor() to work correctly
	move_and_slide(Vector2(10,0), Vector2.UP, true)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	match state:
		NORMAL:
			if !is_on_floor():
				state = FALL
				last_y = global_position.y
			else:
				horizontal()
				if Input.is_action_just_pressed("jump"):
					air_jumps = max_air_jumps
					state = JUMP
					jump()
		JUMP:
			jump()
			pass
		FALL:
			if is_on_floor():
				state = LAND
			elif fall_time <= MIN_FALL_JUMP_TIME:
				air_jumps = max_air_jumps
				jump()
			fall_time += delta
		LAND:
			if $DustTimer.is_stopped() and !$FootDust.emitting:
				$FootDust.emitting = true
				$DustTimer.start($FootDust.lifetime + 0.1)
#			print("fell: %f" % (global_position.y - last_y))
			fall_time = 0
			state = NORMAL
			pass
		DIE:
			pass

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP, true)

func horizontal():
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
			$Anim.play("walk", -1, 1.5)

func jump():
	if air_control:
		horizontal()

	if Input.is_action_just_pressed("jump"):
		$Anim.play("jump")
		state = JUMP
		if air_jumps == max_air_jumps:
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY * AIR_JUMP_MULT

		air_jumps -= 1
		last_y = global_position.y
	elif is_on_floor() and velocity.y >= 0:
		state = LAND








