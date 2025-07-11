extends CharacterBody2D

@export var data: PlayerData

var move_speed

var _w: bool
var _s: bool
var _a: bool
var _d: bool

var _direction = Vector2(0.0, 0.0)

func _ready():
	move_speed = data.move_speed * 10

func _physics_process(_delta: float):
	if GameManager.active_game_state != GameManager.FIGHTING:
		return

	look_at(get_global_mouse_position())
	_update_movement()

func _update_movement():
	_direction = Vector2(
		(_d as float) - (_a as float),
		(_s as float) - (_w as float)
	)
	
	velocity = _direction.normalized() * move_speed
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

func reduce_health(amount: int):
	data.health -= amount
	if data.health <= 0:
		die()

func die():
	GameManager.active_game_state = GameManager.DEATH
	var camera = Camera2D.new()
	get_parent().add_child(camera)
	queue_free()
