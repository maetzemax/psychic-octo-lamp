extends Enemy

@export var projectile_scene: PackedScene

func _perform_attack():
	if player and position.distance_to(player.global_position) < attack_range:
		var projectile = projectile_scene.instantiate()
		projectile.global_position = global_position
		projectile.direction = (player.global_position - global_position).normalized()
		projectile.projectile_speed = data.projectile_speed
		projectile.attack_damage = data.attack_damage
		projectile.collision_mask = 1 | 2
		projectile.collision_layer = 32
		projectile.color = Color.GOLD
		get_tree().current_scene.add_child(projectile)
	is_attacking = false
