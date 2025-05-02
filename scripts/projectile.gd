extends Node2D

class_name Projectile

var data: WeaponData

var direction: Vector2
var velocity: Vector2

var timer: Timer

func _ready():
	timer = Timer.new()
	timer.wait_time = 3
	timer.one_shot = true
	timer.timeout.connect(_on_lifespan_timeout)
	add_child(timer)
	timer.start()

	velocity = direction * data.projectile_speed

func _physics_process(delta: float):
	global_position += velocity * delta

	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.new()
	query.from = global_position
	query.to = global_position + velocity * delta
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.collision_mask = 2
	var result = space_state.intersect_ray(query)
	
	if result:
		if result.collider.has_method("reduce_health"):
			result.collider.reduce_health(data.damage)
		queue_free()

func _on_lifespan_timeout():
	queue_free()
