extends CharacterBody2D

var data: EnemyData
var player: CharacterBody2D

func _ready():
	player = get_tree().get_first_node_in_group("Player") as CharacterBody2D

func _physics_process(delta: float) -> void:
	if player == null:
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * data.move_speed
	move_and_slide()
