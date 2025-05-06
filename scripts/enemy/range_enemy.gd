extends Enemy

@export var projectile_scene: PackedScene

func _perform_attack():
	if not player:
		return
	
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.direction = (player.global_position - global_position).normalized()
	projectile.attack_damage = data.attack_damage
	projectile.collision_mask = 1 | 2
	projectile.collision_layer = 32
	projectile.color = Color.GOLD
	
	if data is RangedEnemyData:
		var ranged_data := data as RangedEnemyData
		projectile.projectile_speed = ranged_data.projectile_speed
	else:
		push_warning("Expected RangedEnemyData, got something else.")
	
	get_tree().current_scene.add_child(projectile)
