extends CharacterBody2D

@onready var left_hand_weapon: Weapon = $LeftHandWeapon
@onready var right_hand_weapon: Weapon = $RightHandWeapon

@export var data: PlayerData

var _w: bool
var _s: bool
var _a: bool
var _d: bool

var _direction = Vector2(0.0, 0.0)

func _physics_process(_delta: float):
	look_at(get_global_mouse_position())
	_update_movement()

func _update_movement():
	_direction = Vector2(
		(_d as float) - (_a as float),
		(_s as float) - (_w as float)
	)
	
	velocity = _direction.normalized() * data.move_speed
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

func _unhandled_input(event):
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_hand_weapon.attack(get_global_mouse_position())
			MOUSE_BUTTON_RIGHT:
				right_hand_weapon.attack(get_global_mouse_position())

func reduce_health(amount: int):
	data.health -= amount
	if data.health <= 0:
		die()

func die():
	queue_free()
