extends Node2D

class_name Weapon

enum WeaponType { MELEE, RANGED }

@export var weapon_data: WeaponData
@export var weapon_type: WeaponType
@export var is_left_hand: bool = false

var attack_cooldown := false
var attack_timer: Timer

func _ready():
	attack_timer = Timer.new()
	attack_timer.wait_time = 1.0 / weapon_data.attack_speed
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_timeout)
	add_child(attack_timer)

func attack(target_position: Vector2):
	if attack_cooldown:
		return

	match weapon_type:
		WeaponType.MELEE:
			_perform_melee_attack(target_position)
		WeaponType.RANGED:
			_perform_ranged_attack(target_position)

	attack_cooldown = true
	attack_timer.start()

func _on_attack_timeout():
	attack_cooldown = false

func _perform_melee_attack(target_position: Vector2):
	var hit_area = RectangleShape2D.new()
	hit_area.extents = Vector2(weapon_data.attack_range, weapon_data.attack_range)

	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = hit_area
	query.transform.origin = global_position.direction_to(target_position) * weapon_data.attack_range + global_position
	query.collide_with_areas = true
	query.collision_mask = 2

	var results = space_state.intersect_shape(query)
	for result in results:
		if result.collider.has_method("reduce_health"):
			result.collider.reduce_health(weapon_data.damage)

func _perform_ranged_attack(target_position: Vector2):
	var projectile_scene = preload("res://scenes/projectile.tscn")
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.direction = (target_position - global_position).normalized()
	projectile.data = weapon_data.duplicate()
	get_tree().current_scene.add_child(projectile)
