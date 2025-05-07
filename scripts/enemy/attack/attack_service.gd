extends Node2D

class_name EnemyAttackService

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

func _ready():
	player = get_tree().get_first_node_in_group("Player")

	attack_timer.wait_time = 1.0 / enemy.data.attack_speed
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)

	cooldown_timer.wait_time = 1.0 / enemy.data.attack_speed
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	add_child(cooldown_timer)
	
func resolve_attack(type: ATTACK.ABILITY):
	if not player or not enemy:
		return

	match type:
		ATTACK.DEFAULT_MELEE:
			default_melee_attack()
		ATTACK.DEFAULT_RANGE:
			default_range_attack()
		ATTACK.DASH:
			dash_attack()
		ATTACK.CHARGE:
			charge_attack()
		ATTACK.BURST:
			burst_attack()
		ATTACK.STAR:
			star_attack()

func default_melee_attack():
	pass

func default_range_attack():
	pass
	
func dash_attack():
	pass
	
func charge_attack():
	pass

func burst_attack():
	pass
	
func star_attack():
	pass

func _on_attack_timer_timeout():
	cooldown_timer.start()

func _on_cooldown_timer_timeout():
	can_attack = true
