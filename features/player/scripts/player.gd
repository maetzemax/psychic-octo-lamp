extends CharacterBody2D

@export var data: PlayerData
@onready var hitbox: Area2D = $Hitbox

var _direction = Vector2.ZERO
var enemy_detection: EnemyDetection

func _ready():
	enemy_detection = EnemyDetection.new(self)
	
	var input_manager = get_node("/root/InputManager")
	input_manager.movement_input_changed.connect(_on_movement_input_changed)

func _physics_process(_delta: float):
	if GameManager.active_game_state != GameManager.ACTIVE:
		return

	var nearest_enemy = enemy_detection.get_nearest_enemy()
	if nearest_enemy:
		var target_angle = (nearest_enemy.global_position - global_position).angle()
		rotation = lerp_angle(rotation, target_angle, 0.2)

	_update_movement()

func _update_movement():
	velocity = _direction.normalized() * Constants.MOVEMENT_SPEED * data.movement_speed
	move_and_slide()

func _on_movement_input_changed(direction: Vector2):
	_direction = direction

func reduce_health(amount: int):
	data.current_health -= amount
	if data.current_health <= 0:
		die()

func die():
	GameManager.active_game_state = GameManager.DIED
	var camera = Camera2D.new()
	get_parent().add_child(camera)
	queue_free()
