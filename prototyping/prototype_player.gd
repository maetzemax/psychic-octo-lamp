extends CharacterBody2D

const SPEED = 300.0

@onready var camera_2d: Camera2D = $Camera2D

func _ready():
	camera_2d.enabled = is_multiplayer_authority()

func _physics_process(_delta: float):
	if not is_multiplayer_authority():
		return
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.x = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
