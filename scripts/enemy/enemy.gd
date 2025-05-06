extends CharacterBody2D

class_name Enemy

@export var data: EnemyData

var movement_service: MovementService

var player: CharacterBody2D
var is_attacking = false
var can_attack = true

var attack_range

@onready var attack_timer: TimerHelper = TimerHelper.new()
@onready var cooldown_timer: TimerHelper = TimerHelper.new()

func _ready():
	player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
	
	movement_service = MovementService.new(self)
	movement_service.enemy = self
	movement_service.target_pos_reached.connect(_on_target_position_reached)
	add_child(movement_service)
	
	attack_range = data.attack_range * 10

	attack_timer.wait_time = 1.0 / data.attack_speed
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)

	cooldown_timer.wait_time = 1.0 / data.attack_speed
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	add_child(cooldown_timer)

func _physics_process(_delta: float):	
	if not player:
		queue_free()
		return
		
	if GameManager.active_game_state != GameManager.FIGHTING:
		return

	if position.distance_to(player.global_position) < attack_range and can_attack:
		_start_attack()
	
	movement_service.resolve_movement(data.move_type)

func _start_attack():
	is_attacking = true
	can_attack = false
	attack_timer.start()

func _perform_attack():
	pass
	
func _on_attack_timer_timeout():
	_perform_attack()
	cooldown_timer.start()

func _on_cooldown_timer_timeout():
	can_attack = true

func reduce_health(amount: int):
	data.health -= amount
	if data.health <= 0:
		die()

func die():
	queue_free()

func _on_target_position_reached():
	pass
