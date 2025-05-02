extends CharacterBody2D

const SPEED = 20.0

var _w: bool
var _s: bool
var _a: bool
var _d: bool

var _direction = Vector2(0.0, 0.0)

func _physics_process(delta: float) -> void:
	_update_movement(delta)

func _update_movement(delta):
	# Computes desired direction from key states
	_direction = Vector2(
		(_d as float) - (_a as float),
		(_s as float) - (_w as float)
	)
	
	velocity = _direction * SPEED
	move_and_slide()

func _input(event: InputEvent):
	if event is InputEventKey:
		match event.keycode:
			KEY_W:
				_w = event.pressed
			KEY_S:
				_s = event.pressed
			KEY_A:
				_a = event.pressed
			KEY_D:
				_d = event.pressed
