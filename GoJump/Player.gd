extends KinematicBody2D

enum PlayerState { NORMAL, JUMP, FALL, LAND, DIE, CLIMB }
const GRAVITY := 800
const JUMP_VELOCITY := -200
const AIR_JUMP_MULT := 0.75
const MIN_FALL_JUMP_TIME := 0.10

onready var velocity := Vector2.ZERO

export var speed := 65
export var air_control := true
export var max_air_jumps := 1

var state:int = PlayerState.NORMAL
var prev_state:int = PlayerState.NORMAL
var air_jumps := 0
var last_y := 0.0
var fall_time := 0.0

#number of climbables the player is hanging onto at any given time
var climbables := 0
var last_climbable_x := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	#Allows the 1st call to is_on_floor() to work correctly
	move_and_slide(Vector2(10,0), Vector2.UP, true)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	match state:
		PlayerState.NORMAL:
			if !is_on_floor():
				change_state(PlayerState.FALL)
				last_y = global_position.y
			else:
				horizontal()
				if Input.is_action_just_pressed("jump"):
					air_jumps = max_air_jumps
					change_state(PlayerState.JUMP)
					jump()
				elif climbables > 0:
					vertical()
					if velocity.y < 0:
						global_position.x = last_climbable_x
						change_state(PlayerState.CLIMB)
				elif $RayCast2D.is_colliding() && Input.is_action_pressed("down"):
					var area = $RayCast2D.get_collider().get_node("Area2D")
					global_position = Vector2(area.global_position.x, global_position.y + 2)
					change_state(PlayerState.CLIMB)
#
		PlayerState.JUMP:
			jump()
		PlayerState.CLIMB:
			climb()
			if is_on_floor() && velocity.y > 0:
				change_state(PlayerState.NORMAL)
		PlayerState.FALL:
			if is_on_floor():
				change_state(PlayerState.LAND)
			elif fall_time <= MIN_FALL_JUMP_TIME:
				air_jumps = max_air_jumps
				jump()
			fall_time += delta
		PlayerState.LAND:
			if $DustTimer.is_stopped() && !$FootDust.emitting && !$RayCast2D.is_colliding():
				$FootDust.emitting = true
				$DustTimer.start($FootDust.lifetime + 0.1)
				if !$Land.playing:
					$Land.play()
#			print("fell: %f" % (global_position.y - last_y))
			fall_time = 0
			change_state(PlayerState.NORMAL)
			pass
		PlayerState.DIE:
			pass

func _physics_process(delta):
	if state != PlayerState.CLIMB:
		velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP, true)

func horizontal():
	var dx = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.x = dx * speed

	if dx != 0:
		$Sprite.flip_h = dx < 0

	if is_on_floor():
		if velocity.x == 0:
			$Anim.play("idle")
		else:
			$Anim.play("walk", -1, 1.5)

func vertical():
	if Input.is_action_pressed("up"):
		velocity.y = -speed / 2.0
	elif Input.is_action_pressed("down"):
		velocity.y = 0.75 * speed
	else:
		velocity.y = 0

	if state == PlayerState.CLIMB:
		if velocity.y == 0:
			$Anim.play("climb_idle")
		else:
			$Anim.play("climb")

func change_state (new_state: int):
#	print("Change state from %d to %d" % [state, new_state])
	prev_state = state
	state = new_state

func jump():
	if air_control:
		horizontal()

	if Input.is_action_just_pressed("jump") && air_jumps >= 0:
		$Anim.play("jump")
		if air_jumps == max_air_jumps:
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY * AIR_JUMP_MULT

		air_jumps -= 1
		last_y = global_position.y
	elif is_on_floor() :
		change_state(PlayerState.LAND)

func climb():
	velocity.x = 0
	vertical()
	if Input.is_action_just_pressed("jump"):
		air_jumps = max_air_jumps
		horizontal()
		change_state(PlayerState.JUMP)
		if velocity.x != 0:
			jump()


func _on_Area2D_area_entered(area):
	if area.type == utils.InteractType.CHAIN or area.type == utils.InteractType.LADDER:
		climbables += 1
		if state == PlayerState.JUMP && (prev_state != PlayerState.CLIMB || last_climbable_x != area.global_position.x):
			global_position.x = area.global_position.x
			change_state(PlayerState.CLIMB)
		last_climbable_x = area.global_position.x


func _on_Area2D_area_exited(area):
	if area.type == utils.InteractType.CHAIN or area.type == utils.InteractType.LADDER:
		climbables = max(0, climbables - 1)
		if climbables == 0 && state == PlayerState.CLIMB:
			$Anim.play("idle")
			change_state(PlayerState.FALL)

func on_play_walk_sfx():
	if !$Step.playing:
		$Step.play()
