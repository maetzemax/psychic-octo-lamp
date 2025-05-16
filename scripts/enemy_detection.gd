extends Node

class_name EnemyDetection

var source_node: Node2D

func _init(source: Node2D):
	source_node = source

func get_nearest_enemy() -> Node2D:
	var nearest_enemy: Node2D = null
	var shortest_distance = INF
	
	var enemies = source_node.get_tree().get_nodes_in_group("Enemy") 

	if enemies:
		for enemy in enemies:
			var distance = source_node.global_position.distance_to(enemy.global_position)
			if distance < shortest_distance:
				shortest_distance = distance
				nearest_enemy = enemy

		return nearest_enemy
	else:
		return null
