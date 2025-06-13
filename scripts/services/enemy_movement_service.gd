extends Node2D

class_name EnemyMovementService

const SEARCH_RADIUS = 300

signal target_pos_reached

var sprite: Sprite2D
var player: CharacterBody2D
var enemy: Enemy

var target_pos: Vector2

func _init(_enemy: Enemy):
	self.enemy = _enemy

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	sprite = get_tree().get_first_node_in_group("World").get_node("Sprite2D")
	
func resolve_movement(type: EnemyMovement.TYPE):
	if not player or not enemy or _colliding_with_player():
		return

	match type:
		EnemyMovement.FOLLOW:
			_follow_movement()
		EnemyMovement.ZICK_ZACK:
			_zick_zack_movement()
		EnemyMovement.RANDOM:
			_random_movement()
		EnemyMovement.SEARCH:
			_search_movement()

func _follow_movement():
	var direction = (player.global_position - global_position).normalized()
	enemy.velocity = direction.normalized() * Constants.MOVEMENT_SPEED * enemy.data.movement_speed
	enemy.look_at(player.global_position)
	
	if enemy.data is RangedEnemyData:
		var ranged_data = enemy.data as RangedEnemyData
		
		if global_position.distance_to(player.global_position) > ranged_data.attack_range * 10:
			enemy.move_and_slide()
	else:
		enemy.move_and_slide()

func _zick_zack_movement():
	pass

func _random_movement():
	if global_position.distance_to(target_pos) < 20 or not target_pos:
		var found_valid_position = false
		
		var angle = randf() * TAU
		var distance = randf_range(0, SEARCH_RADIUS)
		var offset = Vector2(cos(angle), sin(angle)) * distance
		var candidate_pos = global_position + offset

		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(candidate_pos, global_position, 1)
		query.exclude = [self]
		query.collide_with_areas = true
		query.hit_from_inside = true
		var result = space_state.intersect_ray(query)

		if result and result.collider:
			target_pos = result.position
			found_valid_position = true

		target_pos_reached.emit()
	else:
		var direction = (target_pos - global_position).normalized()
		enemy.velocity = direction.normalized() * Constants.MOVEMENT_SPEED * enemy.data.movement_speed
		enemy.move_and_slide()
		
	enemy.look_at(player.global_position)

func _search_movement():
	pass

func _colliding_with_player() -> bool:
	for i in range(enemy.hitbox.get_overlapping_areas().size()):
		var collision = enemy.hitbox.get_overlapping_areas()[i]
		if collision and collision.get_parent().is_in_group("Player"):
			return true
	return false
