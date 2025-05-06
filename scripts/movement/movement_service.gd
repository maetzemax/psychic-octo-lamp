extends Node2D

class_name MovementService

signal target_pos_reached

var player: CharacterBody2D
var enemy: Enemy

var move_speed: float
var target_pos: Vector2

func _init(enemy: Enemy):
	self.enemy = enemy
	move_speed = enemy.data.move_speed * 10

func _ready():
	player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
	
func resolve_movement(type: MOVEMENT.TYPE):
	match type:
		MOVEMENT.FOLLOW:
			follow()
		MOVEMENT.RANDOM:
			random_movement()
		MOVEMENT.SEARCH:
			search()

func follow():
	if not player or not enemy:
		return
		
	look_at(player.global_position)
	var direction = (player.global_position - global_position).normalized()
	enemy.velocity = direction.normalized() * move_speed
	enemy.move_and_slide()
	
func random_movement():
	if global_position.distance_to(target_pos) < 10:
		target_pos_reached.emit()

func search():
	pass
