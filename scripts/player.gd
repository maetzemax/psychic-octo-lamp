extends CharacterBody2D

@export var data: PlayerData

@onready var hitbox: Area2D = $Hitbox

var move_speed

var _up: bool
var _down: bool
var _left: bool
var _right: bool

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
		(_right as float) - (_left as float),
		(_down as float) - (_up as float)
	)
	
	velocity = _direction.normalized() * move_speed
	move_and_slide()

func _input(event: InputEvent):
	if event:
		_up = Input.is_action_pressed("walk_up")
		_down = Input.is_action_pressed("walk_down")
		_left = Input.is_action_pressed("walk_left")
		_right = Input.is_action_pressed("walk_right")

func reduce_health(amount: int):
	data.health -= amount
	if data.health <= 0:
		die()

func die():
	GameManager.active_game_state = GameManager.DEATH
	var camera = Camera2D.new()
	get_parent().add_child(camera)
	queue_free()
