extends CharacterBody2D

class_name Enemy

@export var data: EnemyData

var player: CharacterBody2D
var is_attacking = false
var can_attack = true

@onready var attack_timer: TimerHelper = TimerHelper.new()
@onready var cooldown_timer: TimerHelper = TimerHelper.new()

func _ready():
	player = get_tree().get_first_node_in_group("Player") as CharacterBody2D

	attack_timer.wait_time = 1.0 / data.attack_speed
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)

	cooldown_timer.wait_time = 1.0 / data.attack_speed
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	add_child(cooldown_timer)

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
