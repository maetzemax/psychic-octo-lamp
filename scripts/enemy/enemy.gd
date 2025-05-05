extends CharacterBody2D

class_name Enemy

@export var data: EnemyData

var player: CharacterBody2D
var is_attacking = false
var can_attack = true

var attack_range
var move_speed

@onready var attack_timer: TimerHelper = TimerHelper.new()
@onready var cooldown_timer: TimerHelper = TimerHelper.new()

var target_position: Vector2

func _ready():
	player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
	
	attack_range = data.attack_range * 10
	move_speed = data.move_speed * 10

	attack_timer.wait_time = 1.0 / data.attack_speed
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)

	cooldown_timer.wait_time = 1.0 / data.attack_speed
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	add_child(cooldown_timer)

func _physics_process(_delta: float):
	if not player:
		return
		
	look_at(player.global_position)

	if position.distance_to(player.global_position) < attack_range and can_attack:
		_start_attack()
	
	match data.attack_type:
		ATTACK.MEELE:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction.normalized() * move_speed
			move_and_slide()
		ATTACK.RANGE:
			var random_position: Vector2 = Vector2(
				randi_range(-500, 500),
				randi_range(-500, 500)
			)

			if target_position == null or global_position.distance_to(target_position) < 10:
				target_position = random_position
			
			var direction = (target_position - global_position).normalized()
			velocity = direction.normalized() * move_speed

			if position.distance_to(player.global_position) > attack_range / 4:
				move_and_slide()

func _start_attack():
	is_attacking = true
	can_attack = false
	attack_timer.start()

func _perform_attack():
	pass
	
func _on_attack_timer_timeout():
	_perform_attack()
	cooldown_timer.start()

func _on_cooldown_timer_timeout():
	can_attack = true

func reduce_health(amount: int):
	data.health -= amount
	if data.health <= 0:
		die()

func die():
	queue_free()
