extends Node2D

class_name Projectile

var attack_damage: int
var projectile_speed: float
var collision_mask: int

var direction: Vector2
var velocity: Vector2

var timer: TimerHelper = TimerHelper.new()

func _ready():
	timer.wait_time = 3
	timer.timeout.connect(_on_lifespan_timeout)
	add_child(timer)

	velocity = direction * projectile_speed

func _physics_process(delta: float):
	global_position += velocity * delta

	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.new()
	query.from = global_position
	query.to = global_position + velocity * delta
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.collision_mask = collision_mask
	var result = space_state.intersect_ray(query)
	
	if result:
		if result.collider.has_method("reduce_health"):
			result.collider.reduce_health(attack_damage)
		queue_free()

func _on_lifespan_timeout():
	queue_free()
