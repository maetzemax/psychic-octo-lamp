extends CharacterBody2D

@export var data: PlayerData
@onready var hitbox: Area2D = $Hitbox

var _direction = Vector2.ZERO

func _ready():
	data.current_health = data.health
	
	var input_manager = get_node("/root/InputManager")
	input_manager.movement_input_changed.connect(_on_movement_input_changed)

func _physics_process(_delta: float):
	if GameManager.active_game_state != GameManager.ACTIVE:
		return

	_update_movement()

func _update_movement():
	velocity = _direction.normalized() * Constants.MOVEMENT_SPEED * data.movement_speed
	move_and_slide()

func _on_movement_input_changed(direction: Vector2):
	_direction = direction

func reduce_health(amount: int):
	var damage_taken = max(1, amount - data.armor)
	data.current_health -= damage_taken
	if data.current_health <= 0:
		die()

func die():
	GameManager.set_active_game(GameManager.DIED)
	MaterialService.reset()
	var camera = Camera2D.new()
	get_parent().add_child(camera)
	queue_free()
