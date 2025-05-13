#region Variables Initialization
extends Node2D

class_name EnemyAttackService

signal on_attack

var player: CharacterBody2D
var enemy: Enemy

var can_attack = true

const DASH_RANGE = 200
const DASH_VELOCITY = 500

var dash_direction: Vector2
var is_dashing = false
var can_dash = false

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
	if not _colliding_with_player():
		return
	
	if can_attack:
		on_attack.emit()
		can_attack = false
		cooldown_timer.start()
		player.reduce_health(enemy.data.attack_damage)

func _default_range_attack():
	if enemy.data is RangedEnemyData and can_attack:
		var ranged_data = enemy.data as RangedEnemyData
		if global_position.distance_to(player.global_position) < ranged_data.attack_range * 10:
			var projectile = ranged_data.projectile_scene.instantiate()
			projectile.global_position = global_position
			projectile.direction = (player.global_position - enemy.global_position).normalized()
			projectile.attack_damage = ranged_data.attack_damage
			projectile.collision_mask = 1 | 2
			projectile.collision_layer = 32
			projectile.color = Color.GOLD
			projectile.projectile_speed = ranged_data.projectile_speed
			get_tree().current_scene.add_child(projectile)
			
			on_attack.emit()
			can_attack = false
			cooldown_timer.start()

func _dash_attack():
	if enemy.global_position.distance_to(player.global_position) <= DASH_RANGE and not is_dashing and can_attack:
		dash_direction = (player.global_position - enemy.global_position).normalized() * DASH_VELOCITY
		can_dash = true

	if enemy.global_position.distance_to(player.global_position) > DASH_RANGE and is_dashing:
		can_dash = false
		is_dashing = false
		
	if is_dashing and can_attack:
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
	if GameManager.active_game_state == GameManager.PAUSE:
		return

	if not player or not enemy:
		return
	
	match enemy.data.attack_ability:
		ATTACK.DASH:
			_dash_physics(delta)
		_:
			return

func _dash_physics(_delta: float):
	if can_dash and not is_dashing:
		is_dashing = true
		enemy.velocity = dash_direction
	elif is_dashing:
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
#endregion
