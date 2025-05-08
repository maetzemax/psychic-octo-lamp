#region Variables Initialization
extends Node2D

class_name EnemyAttackService

signal on_attack

var player: CharacterBody2D
var enemy: Enemy

## ENEMY
var is_attacking = false
var can_attack = true

## DASH
const DASH_RANGE = 200
const DASH_VELOCITY = 20
const DASH_FINISH_TIME = 0.1
const DASH_CHARGE_TIME = 0.2

var dash_position: Vector2
var dash_position_reached = false

var is_dashing = false
var can_dash = true

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
	if not player or not enemy or not can_attack:
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
	if not _colliding_with_player():
		return
	
	on_attack.emit()
	can_attack = false
	cooldown_timer.start()
	player.reduce_health(enemy.data.attack_damage)

func _default_range_attack():
	if enemy.data is RangedEnemyData:
		var ranged_data = enemy.data as RangedEnemyData
		if global_position.distance_to(player.global_position) < ranged_data.attack_range * 10:
			var projectile = ranged_data.projectile_scene.instantiate()
			projectile.global_position = global_position
			projectile.direction = (player.global_position - global_position).normalized()
			projectile.attack_damage = ranged_data.attack_damage
			projectile.collision_mask = 1 | 2
			projectile.collision_layer = 32
			projectile.color = Color.GOLD
			projectile.projectile_speed = ranged_data.projectile_speed
			get_tree().current_scene.add_child(projectile)
			
			on_attack.emit()
			can_attack = false
			cooldown_timer.start()
	else:
		push_warning("Expected RangedEnemyData, got something else.")

func _dash_attack():
	if global_position.distance_to(player.global_position) < DASH_RANGE and can_dash and not is_dashing:
		is_dashing = true
		dash_position = player.global_position
		
		await get_tree().create_timer(DASH_CHARGE_TIME).timeout
		
		cooldown_timer.stop()
		can_dash = false
		
	if is_dashing:
		_default_melee_attack()

func _charge_attack():
	pass

func _burst_attack():
	pass
	
func _star_attack():
	pass
#endregion

#region Physics
func _physics_process(delta: float):
	if not player or not enemy or not can_attack:
		return
	
	match enemy.data.attack_ability:
		ATTACK.DASH:
			_dash_physics(delta)
		_:
			return

func _dash_physics(delta: float):
	if is_dashing and not can_dash:
		if global_position.distance_to(dash_position) < 16 and not dash_position_reached:
			dash_position_reached = true
			await get_tree().create_timer(DASH_FINISH_TIME).timeout
			is_dashing = false
			cooldown_timer.start()
		elif _colliding_with_player():
			is_dashing = false
			cooldown_timer.start()
		else:
			enemy.velocity = lerp(enemy.velocity, (dash_position - global_position) * DASH_VELOCITY, delta)
			enemy.move_and_slide()
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
	can_dash = true
	dash_position_reached = false
#endregion
