extends Node2D

class_name EnemyAttackService

signal on_attack

var player: CharacterBody2D

var is_attacking = false
var can_attack = true

var enemy: Enemy
var attack_range: float
var target_pos: Vector2

var attack_timer: TimerHelper = TimerHelper.new()
var cooldown_timer: TimerHelper = TimerHelper.new()

func _init(enemy: Enemy):
	self.enemy = enemy
	attack_range = enemy.data.attack_range * 10

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	
	attack_range = enemy.data.attack_range * 10

	attack_timer.wait_time = 1.0 / enemy.data.attack_speed
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)

	cooldown_timer.wait_time = 1.0 / enemy.data.attack_speed
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	add_child(cooldown_timer)
	
func resolve_attack(type: ATTACK.TYPE):
	if not player or not enemy:
		return

	match type:
		ATTACK.DEFAULT:
			if position.distance_to(player.global_position) < attack_range and can_attack:
				_start_attack()
		ATTACK.DASH:
			pass
		ATTACK.CHARGE:
			pass
		ATTACK.BURST:
			pass
		ATTACK.STAR:
			pass

func _start_attack():
	is_attacking = true
	can_attack = false
	attack_timer.start()

func _on_attack_timer_timeout():
	on_attack.emit()
	cooldown_timer.start()

func _on_cooldown_timer_timeout():
	can_attack = true
