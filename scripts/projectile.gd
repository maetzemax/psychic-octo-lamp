extends Area2D

class_name Projectile

var attack_damage: int
var projectile_speed: float
var color: Color = Color.BLACK

var direction: Vector2
var velocity: Vector2

var timer: TimerHelper = TimerHelper.new()

func _ready():
	$Mesh.modulate = color
	timer.wait_time = 3
	timer.timeout.connect(_on_lifespan_timeout)
	add_child(timer)

	velocity = direction * projectile_speed * 10

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

func _on_lifespan_timeout():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body and body.has_method("reduce_health"):
		body.reduce_health(attack_damage)
	
	queue_free()
