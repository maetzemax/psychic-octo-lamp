extends Node2D

class_name MovementService

signal target_pos_reached

var world_mesh: MeshInstance2D
var player: CharacterBody2D

var enemy: Enemy
var move_speed: float
var target_pos: Vector2

func _init(enemy: Enemy):
	self.enemy = enemy
	move_speed = enemy.data.move_speed * 10

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	world_mesh = get_tree().get_first_node_in_group("World").get_node("Mesh")
	
func resolve_movement(type: MOVEMENT.TYPE):
	if not player or not enemy:
		return

	match type:
		MOVEMENT.FOLLOW:
			follow()
		MOVEMENT.RANDOM:
			random_movement()
		MOVEMENT.SEARCH:
			search()

func follow():	
	var direction = (player.global_position - global_position).normalized()	
	enemy.velocity = direction.normalized() * move_speed
	enemy.move_and_slide()
	enemy.look_at(player.global_position)
	
func random_movement():	
	if global_position.distance_to(target_pos) < 10 or target_pos == Vector2.ZERO:
		var world_size = (world_mesh.mesh.size.x - 32) / 2
	
		var random_pos: Vector2 = Vector2(
			randi_range(-world_size, world_size),
			randi_range(-world_size, world_size)
		)

		target_pos = random_pos
			
		var direction = (target_pos - global_position).normalized()
		enemy.velocity = direction.normalized() * move_speed
		enemy.move_and_slide()
		
		target_pos_reached.emit()
	else:
		var direction = (target_pos - global_position).normalized()
		enemy.velocity = direction.normalized() * move_speed
		enemy.move_and_slide()
		
	enemy.look_at(player.global_position)

func search():
	pass
