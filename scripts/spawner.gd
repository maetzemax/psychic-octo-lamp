extends Node2D

@export var enemies: Array[EnemyData]
@export var world: Node2D
@export var player: CharacterBody2D

var spawn_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
	spawn_timer = Timer.new()
	spawn_timer.autostart = true
	spawn_timer.wait_time = 5
	spawn_timer.timeout.connect(_on_timeout)
	add_child(spawn_timer)

func _on_timeout():
	_spawn_enemies()

func _spawn_enemies():
	var spawn_areas := world.get_node("SpawnAreas")
	var valid_spawn_rects: Array[Rect2] = []

	# Suche alle gültigen Spawnbereiche
	for spawn in spawn_areas.get_children():
		if not spawn is StaticBody2D:
			continue

		var shape_node := spawn.get_node_or_null("SpawnArea")
		if shape_node == null:
			continue

		var rect_shape := shape_node.shape as RectangleShape2D
		var rect = Rect2(
			shape_node.global_position - rect_shape.extents,
			rect_shape.extents * 2
		)

		# Spieler darf nicht im Spawnbereich sein
		if not rect.has_point(player.global_position):
			valid_spawn_rects.append(rect)

	if valid_spawn_rects.is_empty():
		print("Keine gültigen Spawnbereiche verfügbar.")
		return

	# Wähle zufällig einen gültigen Bereich
	var selected_rect = valid_spawn_rects[randi() % valid_spawn_rects.size()]

	# Gruppenzentrum leicht zufällig innerhalb des Bereichs
	var center_x = randf_range(
		selected_rect.position.x + 15, selected_rect.position.x + selected_rect.size.x - 15
	)
	var center_y = randf_range(
		selected_rect.position.y + 15, selected_rect.position.y + selected_rect.size.y - 15
	)
	var group_center = Vector2(center_x, center_y)

	var group_size = randi_range(3, 7)
	for i in group_size:
		# Gegner in engem Radius um Gruppenzentrum
		var offset = Vector2(randf_range(-5, 5), randf_range(-5, 5))
		var spawn_pos = group_center + offset

		# Gegnerdaten & Instanz
		var enemy_data = enemies[randi() % enemies.size()]
		var enemy_scene = enemy_data.model
		var enemy = enemy_scene.instantiate()
		enemy.data = enemy_data
		enemy.global_position = spawn_pos
		add_child(enemy)
