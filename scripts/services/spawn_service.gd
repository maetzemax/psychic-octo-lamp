extends Node2D

@export var world: Node2D
@export var player: CharacterBody2D

@export var wave_service: WaveService

var spawn_timer: TimerHelper
var enemies: Array[EnemyData]

var spawn_cooldown: float

var min_enemy_amount: int = 1
var max_enemy_amount: int = 5

func _on_timeout():
	_spawn_enemies()

func _spawn_enemies():
	if !player or !wave_service.active_wave:
		return
	
	var spawn_areas := world.get_node("SpawnAreas")
	var valid_spawn_rects: Array[Rect2] = []

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

		if not rect.has_point(player.global_position):
			valid_spawn_rects.append(rect)

	if valid_spawn_rects.is_empty():
		print("Keine gültigen Spawnbereiche verfügbar.")
		return

	var selected_rect = valid_spawn_rects[randi() % valid_spawn_rects.size()]

	var center_x = randf_range(
		selected_rect.position.x + 32, selected_rect.position.x + selected_rect.size.x - 32
	)
	var center_y = randf_range(
		selected_rect.position.y + 32, selected_rect.position.y + selected_rect.size.y - 32
	)
	var group_center = Vector2(center_x, center_y)

	for i in range(randi_range(min_enemy_amount, max_enemy_amount)):
		var offset = Vector2(randf_range(-128, 128), randf_range(-128, 128))
		var spawn_pos = group_center + offset

		var enemy_data = enemies[randi() % enemies.size()]
		var enemy_scene = enemy_data.model
		var enemy = enemy_scene.instantiate()
		enemy.data = enemy_data.duplicate()
		enemy.global_position = spawn_pos
		add_child(enemy)

func setup_timer():
	if wave_service.active_wave == null:
		push_error("setup_timer: Es gibt keine aktive Wave!")
		return

	spawn_cooldown = wave_service.active_wave.spawn_cooldown
	enemies = wave_service.active_wave.enemies
	min_enemy_amount = wave_service.active_wave.min_spawn_amount
	max_enemy_amount = wave_service.active_wave.max_spawn_amount

	# Timer zurücksetzen
	if spawn_timer:
		spawn_timer.queue_free()

	randomize()
	spawn_timer = TimerHelper.new()
	spawn_timer.autostart = true
	spawn_timer.wait_time = spawn_cooldown
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(_on_timeout)
	add_child(spawn_timer)
