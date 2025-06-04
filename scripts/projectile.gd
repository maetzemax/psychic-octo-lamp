extends Area2D

class_name Projectile

var attack_damage: int
var projectile_speed: float

var direction: Vector2
var velocity: Vector2

func _ready() -> void:
	velocity = direction * projectile_speed * 10

func _physics_process(delta: float):
	if GameManager.active_game_state != GameManager.ACTIVE:
		return
	
	global_position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body and body.has_method("reduce_health"):
		body.reduce_health(attack_damage)
	
	queue_free()
