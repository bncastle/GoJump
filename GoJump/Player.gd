extends KinematicBody2D

const GRAVITY := 800

onready var velocity := Vector2.ZERO

export var speed := 65
export var air_control := true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace wqith function body

func _process(delta):
	horizontal()

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
