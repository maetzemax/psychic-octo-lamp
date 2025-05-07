#region Variables Initialization
extends Node2D

class_name EnemyAttackService

signal on_attack

var player: CharacterBody2D
var enemy: Enemy

var is_attacking = false
var can_attack = true

var cooldown_timer: TimerHelper = TimerHelper.new()

func _init(enemy: Enemy):
	self.enemy = enemy

func _ready():
	player = get_tree().get_first_node_in_group("Player")

	cooldown_timer.wait_time = 1.0 / enemy.data.attack_speed
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	add_child(cooldown_timer)
#endregion
	
#region Attack
func resolve_attack(type: ATTACK.ABILITY):
	if not player or not enemy:
		return

	match type:
		ATTACK.DEFAULT_MELEE:
			_default_melee_attack()
		ATTACK.DEFAULT_RANGE:
			_default_range_attack()
		ATTACK.DASH:
			_dash_attack()
		ATTACK.CHARGE:
			_charge_attack()
		ATTACK.BURST:
			_burst_attack()
		ATTACK.STAR:
			_star_attack()

func _default_melee_attack():
	if not _colliding_with_player() or not can_attack:
		return
	
	on_attack.emit()
	can_attack = false
	cooldown_timer.start()
	player.reduce_health(enemy.data.attack_damage)

func _default_range_attack():
	pass

func _dash_attack():
	pass

func _charge_attack():
	pass

func _burst_attack():
	pass
	
func _star_attack():
	pass
#endregion
	
#region Helper
func _colliding_with_player() -> bool:
	for i in range(enemy.hitbox.get_overlapping_areas().size()):
		var collision = enemy.hitbox.get_overlapping_areas()[i]
		if collision and collision.get_parent().is_in_group("Player"):
			return true
	return false

func _on_cooldown_timer_timeout():
	can_attack = true
#endregion
