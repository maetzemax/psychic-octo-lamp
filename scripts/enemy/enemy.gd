extends CharacterBody2D

class_name Enemy

@export var data: EnemyData

@onready var hitbox: Area2D = $Hitbox

var movement_service: MovementService
var enemy_attack_service: EnemyAttackService

var player: CharacterBody2D

func _ready():
	player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
	
	movement_service = MovementService.new(self)
	movement_service.target_pos_reached.connect(_on_target_position_reached)
	add_child(movement_service)
	
	enemy_attack_service = EnemyAttackService.new(self)
	add_child(enemy_attack_service)

func _physics_process(_delta: float):
	if not player:
		queue_free()
		return
		
	if GameManager.active_game_state != GameManager.FIGHTING:
		return
	
	enemy_attack_service.resolve_attack(data.attack_ability)
	
	if not enemy_attack_service.is_dashing:
		movement_service.resolve_movement(data.move_type)

func reduce_health(amount: int):
	data.health -= amount
	if data.health <= 0:
		die()

func die():
	var material_scene = preload("res://scenes/assets/material.tscn")
	var material_instance = material_scene.instantiate()
	material_instance.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", material_instance)
	queue_free()

func _on_target_position_reached():
	pass
