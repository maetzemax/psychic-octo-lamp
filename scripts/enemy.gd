extends CharacterBody2D

@export var data: EnemyData

var player: CharacterBody2D
var is_attacking = false
var can_attack = true

var attack_timer: Timer
var cooldown_timer: Timer

@onready var attack_indicator: MeshInstance2D = $AttackIndicator
var indicator_target_radius := 0.0
var indicator_current_radius := 0.0
const SCALE_SPEED := 6.0

func _ready():
	player = get_tree().get_first_node_in_group("Player") as CharacterBody2D

	attack_timer = Timer.new()
	attack_timer.wait_time = 1.0 / data.attack_speed
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)

	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = 1.0 / data.attack_speed
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	add_child(cooldown_timer)

	attack_indicator.visible = false
	_reset_attack_indicator()

func _physics_process(delta: float) -> void:
	if not player:
		return
		
	look_at(player.global_position)

	if position.distance_to(player.global_position) < data.attack_range and can_attack:
		_start_attack()

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * data.move_speed
	
	move_and_slide()

func _start_attack():
	is_attacking = true
	can_attack = false
	attack_indicator.visible = true
	indicator_target_radius = data.attack_range
	indicator_current_radius = 0.0
	_update_attack_indicator_mesh(0.0)
	attack_timer.start()

func _on_attack_timer_timeout():
	_perform_attack()
	_reset_attack_indicator()
	cooldown_timer.start()

func _perform_attack():
	if player and position.distance_to(player.global_position) < data.attack_range:
		player.reduce_health(data.damage)
	is_attacking = false

func _on_cooldown_timer_timeout():
	can_attack = true

func _process(delta):
	if is_attacking:
		indicator_current_radius = lerp(indicator_current_radius, indicator_target_radius, delta * SCALE_SPEED)
		_update_attack_indicator_mesh(indicator_current_radius)

func _update_attack_indicator_mesh(radius: float):
	var circle_mesh = SphereMesh.new()
	# -1 == half player size
	circle_mesh.radius = radius - 1
	circle_mesh.height = (radius - 1) * 2.0
	attack_indicator.mesh = circle_mesh

func _reset_attack_indicator():
	attack_indicator.visible = false
	indicator_current_radius = 0.0
	indicator_target_radius = 0.0
	_update_attack_indicator_mesh(0.0)
