extends Node2D

class_name Weapon

const LAYER_WORLD = 1 << 0
const LAYER_ENEMY_MELEE = 1 << 2
const LAYER_ENEMY_RANGED = 1 << 3

@export var data: WeaponData

var attack_cooldown := false
var attack_timer: TimerHelper = TimerHelper.new()

func _ready():
	attack_timer.wait_time = 1.0 / data.attack_speed
	attack_timer.timeout.connect(_on_attack_timeout)
	add_child(attack_timer)
	
func _physics_process(_delta: float):
	attack(get_global_mouse_position())

func attack(target_position: Vector2):
	if attack_cooldown:
		return

	match data.attack_type:
		ATTACK.MEELE:
			_perform_melee_attack(target_position)
		ATTACK.RANGE:
			_perform_ranged_attack(target_position)

	attack_cooldown = true
	attack_timer.start()

func _on_attack_timeout():
	attack_cooldown = false

func _perform_melee_attack(target_position: Vector2):
	var hit_area = RectangleShape2D.new()
	hit_area.extents = Vector2(data.attack_range, data.attack_range)

	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = hit_area
	query.transform.origin = global_position.direction_to(target_position) * data.attack_range + global_position
	query.collide_with_areas = true
	query.collision_mask = 2

	var results = space_state.intersect_shape(query)
	for result in results:
		if result.collider.has_method("reduce_health"):
			result.collider.reduce_health(data.damage)

func _perform_ranged_attack(target_position: Vector2):
	var projectile_scene = preload("res://scenes/projectile.tscn")
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.direction = (target_position - global_position).normalized()
	projectile.projectile_speed = data.projectile_speed
	projectile.attack_damage = data.attack_damage
	projectile.collision_mask = LAYER_ENEMY_MELEE | LAYER_ENEMY_RANGED | LAYER_WORLD
	projectile.collision_layer = 32
	get_tree().current_scene.add_child(projectile)
